// importing
import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import SystemTray from "resource:///com/github/Aylur/ags/service/systemtray.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";
import Sway from "./sway.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import PopupWindow from "./popupWindow.js";
import GLib from "gi://GLib";
import KhalService from "./khalService.js";
import {
  NotificationList,
  DNDSwitch,
  ClearButton,
  PopupList,
} from "./notifications-widget.js";

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, just make it a function
// then you can use it by calling simply calling it

const getWorkspaceClassName = (ws) => {
  if (Sway.active.workspace.name == ws.name) return "focused";
  else if (ws.urgent) return "urgent";
  return "";
};

const Workspaces = (monitorName) =>
  Widget.Box({
    className: "workspaces",
    connections: [
      [
        Sway.active.workspace,
        (self) => {
          self.children = Sway.workspaces
            .filter((w) => w.output === monitorName)
            .map((i) => {
              return Widget.Button({
                onClicked: () => execAsync(`swaymsg workspace ${i.name}`),
                child: Widget.Label(`${i.name}`),
                className: getWorkspaceClassName(i),
              });
            });
        },
      ],
    ],
  });

const Clock = () =>
  Widget.Label({
    className: "clock",
    connections: [
      [
        1000,
        (self) =>
          execAsync(["date", "+%H:%M"])
            .then((date) => (self.label = date))
            .catch(console.error),
      ],
    ],
  });

const DateBox = () =>
  Widget.Button({
    className: "date",
    onClicked: () => App.toggleWindow("dashboard"),
    connections: [
      [
        60000,
        (self) =>
          execAsync(["date", "+%a, %e %b %Y"])
            .then((date) => (self.label = date))
            .catch(console.error),
      ],
    ],
  });

// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
const Notification = () =>
  Widget.Button({
    className: "notification",
    onClicked: () => App.toggleWindow("notification-center"),
    child: Widget.Box({
      spacing: 0,
      children: [
        Widget.Stack({
          items: [
            [
              "enabled",
              Widget.Icon("preferences-system-notifications-symbolic"),
            ],
            ["disabled", Widget.Icon("notifications-disabled-symbolic")],
          ],
          connections: [
            [
              Notifications,
              (self) => {
                self.shown = Notifications.dnd ? "disabled" : "enabled";
              },
            ],
          ],
        }),
        Widget.Label({
          className: "emblem",
          binds: [
            [
              "label",
              Notifications,
              "notifications",
              (p) => p.length.toString(),
            ],
          ],
        }),
      ],
    }),
  });

const Volume = () =>
  Widget.Box({
    className: "volume",
    children: [
      Widget.Stack({
        items: [
          // tuples of [string, Widget]
          ["101", Widget.Icon("audio-volume-overamplified-symbolic")],
          ["67", Widget.Icon("audio-volume-high-symbolic")],
          ["34", Widget.Icon("audio-volume-medium-symbolic")],
          ["1", Widget.Icon("audio-volume-low-symbolic")],
          ["0", Widget.Icon("audio-volume-muted-symbolic")],
        ],
        connections: [
          [
            Audio,
            (self) => {
              if (!Audio.speaker) return;

              if (Audio.speaker.stream.isMuted) {
                self.shown = "0";
                return;
              }

              const show = [101, 67, 34, 1, 0].find(
                (threshold) => threshold <= Audio.speaker.volume * 100
              );

              self.shown = `${show}`;
            },
            "speaker-changed",
          ],
        ],
      }),
    ],
  });

const Mic = () =>
  Widget.Box({
    className: "mic",
    children: [
      Widget.Stack({
        items: [
          // tuples of [string, Widget]
          ["unmuted", Widget.Icon("microphone-sensitivity-high-symbolic")],
          ["muted", Widget.Icon("microphone-sensitivity-muted-symbolic")],
        ],
        connections: [
          [
            Audio,
            (self) => {
              if (!Audio.microphone) return;

              self.shown = Audio.microphone.stream.isMuted
                ? "muted"
                : "unmuted";
            },
            "microphone-changed",
          ],
        ],
      }),
    ],
  });

const BatteryLabel = () =>
  Widget.Box({
    className: "battery",
    children: [
      Widget.Icon({
        connections: [
          [
            Battery,
            (self) => {
              self.icon = `battery-level-${
                Math.floor(Battery.percent / 10) * 10
              }-symbolic`;
            },
          ],
        ],
      }),
    ],
  });

const SysTray = () =>
  Widget.Box({
    connections: [
      [
        SystemTray,
        (self) => {
          self.children = SystemTray.items.map((item) =>
            Widget.Button({
              child: Widget.Icon({ binds: [["icon", item, "icon"]] }),
              onPrimaryClick: (_, event) => item.activate(event),
              onSecondaryClick: (_, event) => item.openMenu(event),
              binds: [["tooltip-markup", item, "tooltip-markup"]],
            })
          );
        },
      ],
    ],
  });

const SsidPopup = ({ anchor = ["top", "right"], layout = "top" } = {}) =>
  PopupWindow({
    name: "ssidPopup",
    layout,
    anchor,
    content: Widget.Box({
      vertical: true,
      children: [
        Widget.Label({
          connections: [
            [
              Network,
              (self) => {
                self.label = Network.wifi?.ssid;
              },
            ],
          ],
        }),
        Widget.Label({
          connections: [
            [
              Network,
              (self) => {
                self.label = Network.wifi?.strength.toString() + "%";
              },
            ],
          ],
        }),
      ],
    }),
  });

const WifiIndicator = () =>
  Widget.Button({
    child: Widget.Icon({
      connections: [
        [
          Network,
          (self) => {
            if (Network.wifi?.iconName) self.icon = Network.wifi.iconName;
          },
        ],
      ],
    }),
    onClicked: () => App.toggleWindow("ssidPopup"),
  });

const WiredIndicator = () =>
  Widget.Icon({
    connections: [
      [
        Network,
        (self) => {
          self.icon = Network.wired.iconName;
        },
      ],
    ],
  });

const NetworkIndicator = () =>
  Widget.Stack({
    items: [
      ["wifi", WifiIndicator()],
      ["wired", WiredIndicator()],
    ],
    binds: [["shown", Network, "primary", (p) => p || "wifi"]],
  });

const VpnIndicator = () =>
  Widget.Icon({
    icon: "network-vpn-symbolic",
    connections: [
      [
        60000,
        (self) => {
          execAsync("openvpn3 sessions-list")
            .then((out) => {
              self.visible = !out.includes("No sessions available");
            })
            .catch(console.error);
        },
      ],
    ],
  });

// const memoryIcon = "\ue266";
const ComputerResources = () =>
  Widget.Box({
    spacing: 12,
    children: [
      Widget.Icon("speedometer-symbolic"),
      Widget.Icon("media-flash-symbolic"),
    ],
  });

const githubIcon = "\uf113";
const GithubPR = () =>
  Widget.Button({
    onClicked: () =>
      execAsync("xdg-open https://github.com/pulls/review-requested"),
    child: Widget.Box({
      children: [
        Widget.Label(githubIcon),
        Widget.Stack({
          items: [
            [
              "NoPending",
              Widget.Icon({
                icon: "emblem-ok-symbolic",
                className: "emblem ok",
              }),
            ],
            [
              "PendingPR",
              Widget.Icon({
                icon: "dialog-warning-symbolic",
                className: "emblem nok",
              }),
            ],
          ],
          connections: [
            [
              120000, // 2mins
              (self) =>
                execAsync("/home/rodrigosilva/.config/ags/github-pr.sh")
                  .then((output) => {
                    // TODO: Move this code to its Service
                    output = output.replaceAll("\u000d", ""); // Remove color
                    const jsonOutput = JSON.parse(output);
                    self.shown = jsonOutput.count ? "PendingPR" : "NoPending";
                  })
                  .catch(console.error),
            ],
          ],
        }),
      ],
    }),
  });

const markupTransform = (unsafe) => {
  if (!unsafe) return unsafe;

  return unsafe.replaceAll('&', '&amp;')
   .replaceAll('<', '&lt;')
   .replaceAll('>', '&gt;');
};

const CalendarEvents = ({ anchor = ["top", "right"], layout = "top right" } = {}) =>
  PopupWindow({
    name: "calendarEvents",
    layout,
    anchor,
    content: Widget.Box({
      vertical: true,
      className: "calender-events-container",
      connections: [
        [
          KhalService,
          (self) => {
            if (!KhalService.eventsByDay?.length) {
              return;
            }

            self.children = KhalService.eventsByDay.map((eventDay) => {
              // Add move this code to KhalService and add defensive code;
              const regex = /(\d\d)\/(\d\d)\/(\d\d\d\d)/;
              const match = regex.exec(eventDay.day);
              const date = new Date(match[3], match[2] - 1, match[1]);

              const dayName =
                date.getDate() == new Date().getDate()
                  ? "Today"
                  : date.getDate() == new Date().getDate() + 1
                  ? "Tomorrow"
                  : "Day after Tomorrow";

              return Widget.Box({
                vertical: true,
                spacing: 10,
                className: "event-day",
                children: [
                  Widget.Box({
                    hexpand: true,
                    children: [
                      // Add function to format date
                      Widget.Label({
                        className: "header",
                        justification: "left",
                        xalign: 0,
                        hexpand: true,
                        label: dayName,
                        visible: dayName != "",
                      }),
                      Widget.Label({
                        className: "header",
                        justification: "right",
                        xalign: 1,
                        label: date.toLocaleDateString("pt-BR", {
                          weekday: "short",
                          day: "numeric",
                          month: "short",
                        }),
                      }),
                    ],
                  }),
                  Widget.Box({
                    vertical: true,
                    children: eventDay.events.map((event) =>
                      Widget.Label({
                        name: "id-" + event.uid,
                        className: "event-line",
                        label: `${event.startTime}-${event.endTime}: ${markupTransform(event.title)}${event.repeatSymbol}`,
                        justification: "left",
                        xalign: 0,
                        useMarkup: true,
                      })
                    ),
                  }),
                ],
              });
            });
          },
        ],
      ],
    }),
  });

const CalendarNextEvent = () =>
  Widget.Button({
    onClicked: () => App.toggleWindow("calendarEvents"),
    child: Widget.Box({
      spacing: 5,
      children: [
        Widget.Icon("x-office-calendar-symbolic"),
        Widget.Label({
          useMarkup: true,
          connections: [
            [
              KhalService,
              (self) => {
                if (!KhalService.calendarEvents?.length) {
                  self.label = "No Next Event";
                  return;
                }
                const event = KhalService.calendarEvents[0];
                self.label = `${event.startTime}-${event.endTime}: ${markupTransform(event.title)}${event.repeatSymbol}`;
              },
            ],
          ],
        }),
      ],
    }),
  });

const Header = () =>
  Widget.Box({
    className: "header",
    children: [
      Widget.Label("Do Not Disturb"),
      DNDSwitch(),
      Widget.Box({ hexpand: true }),
      ClearButton(),
    ],
  });

const NotificationCenter = () =>
  Widget.Window({
    name: "notification-center",
    className: "notification-feat",
    anchor: ["right", "top", "bottom"],
    popup: true,
    focusable: true,
    visible: false,
    child: Widget.Box({
      children: [
        Widget.EventBox({
          hexpand: true,
          connections: [
            [
              "button-press-event",
              () => App.closeWindow("notification-center"),
            ],
          ],
        }),
        Widget.Box({
          vertical: true,
          children: [Header(), NotificationList()],
        }),
      ],
    }),
  });

const NotificationsPopupWindow = () =>
  Widget.Window({
    name: "popup-window",
    className: "notification-feat",
    anchor: ["top"],
    child: PopupList(),
  });

// layout of the bar
const Left = (monitorName) =>
  Widget.Box({
    className: "left",
    children: [Workspaces(monitorName)],
  });

const Center = () =>
  Widget.Box({
    className: "center",
    children: [DateBox()],
  });

const Right = () =>
  Widget.Box({
    className: "right",
    spacing: 12,
    halign: "end",
    children: [
      CalendarNextEvent(),
      GithubPR(),
      ComputerResources(),
      NetworkIndicator(),
      VpnIndicator(),
      BatteryLabel(),
      Volume(),
      Mic(),
      Notification(),
      SysTray(),
      Clock(),
    ],
  });

const Bar = (monitorId, monitorName) =>
  Widget.Window({
    name: `bar-${monitorName}`, // name has to be unique
    className: "bar",
    monitor: monitorId,
    anchor: ["top", "left", "right"],
    exclusive: true,
    child: Widget.CenterBox({
      startWidget: Left(monitorName),
      centerWidget: Center(),
      endWidget: Right(),
    }),
  });

const Clock2 = ({
  format = "%H:%M:%S %B %e. %A",
  interval = 1000,
  ...props
} = {}) =>
  Widget.Label({
    className: "clock",
    ...props,
    connections: [
      [
        interval,
        (label) => (label.label = GLib.DateTime.new_now_local().format(format)),
      ],
    ],
  });
const DateColumn = () =>
  Widget.Box({
    vertical: true,
    className: "datemenu",
    children: [
      Clock2({ format: "%H:%M" }),
      Widget.Box({
        className: "calendar",
        children: [
          Widget({
            type: imports.gi.Gtk.Calendar,
            hexpand: true,
            halign: "center",
          }),
        ],
      }),
    ],
  });

const Calendar = ({ anchor = ["top"], layout = "top" } = {}) =>
  PopupWindow({
    name: "dashboard",
    layout,
    anchor,
    content: Widget.Box({
      className: "dashboard",
      children: [DateColumn()],
    }),
  });

// TODO: Add defensive code
const monitors = JSON.parse(await execAsync("swaymsg -r -t get_outputs"));

function forAllMonitors(widget) {
  return monitors.map((mon, index) => widget(index, mon.name));
}

// exporting the config so ags can manage the windows
export default {
  style: App.configDir + "/style.css",
  windows: forAllMonitors(Bar)
    .concat(Calendar())
    .concat(CalendarEvents())
    .concat(SsidPopup())
    .concat(NotificationsPopupWindow())
    .concat(NotificationCenter()),
};
