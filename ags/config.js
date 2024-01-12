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

import PopupWindow from "./PopupWindow2.js";

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
    class_name: "workspaces",
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
                class_name: getWorkspaceClassName(i),
              });
            });
        },
      ],
    ],
  });

const Clock = () =>
  Widget.Label({
    class_name: "clock",
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
    class_name: "date",
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
    class_name: "notification",
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
          class_name: "emblem",
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
    class_name: "volume",
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
    class_name: "mic",
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
    class_name: "battery",
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
          self.children = SystemTray.items.map((item) => {
            return Widget.Button({
              child: Widget.Icon({
                binds: [["icon", item, "icon"]]
              }),
              onPrimaryClick: (_, event) => item.activate(event),
              onSecondaryClick: (_, event) => item.openMenu(event),
              binds: [["tooltip-markup", item, "tooltip-markup"]],
            });
          });
        },
      ],
    ],
  });

const SsidPopup = () =>
  PopupWindow({
    name: "ssidPopup",
    anchor: ['top', 'right'],
    transition: 'slide_down',
    child: Widget.Box({
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
                class_name: "emblem ok",
              }),
            ],
            [
              "PendingPR",
              Widget.Icon({
                icon: "dialog-warning-symbolic",
                class_name: "emblem nok",
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

  return unsafe
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;");
};

const CalendarEvents = () =>
  PopupWindow({
    name: "calendar-events",
    anchor:["top", "right"],
    transition: 'slide_down',
    child: Widget.Box({
      vertical: true,
      class_name: "calender-events-container",
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
                class_name: "event-day",
                children: [
                  Widget.Box({
                    hexpand: true,
                    children: [
                      // Add function to format date
                      Widget.Label({
                        class_name: "header",
                        justification: "left",
                        xalign: 0,
                        hexpand: true,
                        label: dayName,
                        visible: dayName != "",
                      }),
                      Widget.Label({
                        class_name: "header",
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
                        class_name: "event-line",
                        label: `${event.startTime}-${
                          event.endTime
                        }: ${markupTransform(event.title)}${
                          event.repeatSymbol
                        }`,
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
    onClicked: () => App.toggleWindow("calendar-events"),
    child: Widget.Box({
      spacing: 5,
      connections: [
        [
          KhalService,
          (self) => {
            const nextEvent = !KhalService.calendarEvents?.length
              ? null
              : KhalService.calendarEvents[0];

            self.children = [
              Widget.Icon("x-office-calendar-symbolic"),
              Widget.Label({
                useMarkup: true,
                label: !nextEvent
                  ? "No Next Event"
                  : `${nextEvent.startTime}-${
                      nextEvent.endTime
                    }: ${markupTransform(nextEvent.title)}${
                      nextEvent.repeatSymbol
                    }`,
              }),
            ];
          },
        ],
      ],
    }),
  });

const Header = () =>
  Widget.Box({
    class_name: "header",
    children: [
      Widget.Label("Do Not Disturb"),
      DNDSwitch(),
      Widget.Box({ hexpand: true }),
      ClearButton(),
    ],
  });

const NotificationCenter = () =>
  PopupWindow({
    name: "notification-center",
    class_name: "notification-feat",
    anchor: ["right", "top", "bottom"],
    transition: 'slide_down',
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
    class_name: "notification-feat",
    anchor: ["top"],
    child: PopupList(),
  });

// layout of the bar
const Left = (monitorName) =>
  Widget.Box({
    class_name: "left",
    children: [Workspaces(monitorName)],
  });

const Center = () =>
  Widget.Box({
    class_name: "center",
    hexpand: true,
    children: [DateBox()],
  });

const Right = () =>
  Widget.Box({
    class_name: "end",
    spacing: 12,
    children: [
      Widget.Box({ hexpand: true }),
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
    class_name: "bar",
    monitor: monitorId,
    anchor: ["top", "left", "right"],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
      start_widget: Left(monitorName),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });

const Clock2 = ({
  format = "%H:%M:%S %B %e. %A",
  interval = 1000,
  ...props
} = {}) =>
  Widget.Label({
    class_name: "clock",
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
    class_name: "datemenu",
    children: [
      Clock2({ format: "%H:%M" }),
      Widget.Box({
        class_name: "calendar",
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

const Calendar = () =>
  PopupWindow({
    name: "dashboard",
    anchor: ['top'],
    transition: 'slide_down',
    child: Widget.Box({
      class_name: "dashboard",
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
  windows: 
  forAllMonitors(Bar)
    .concat(Calendar())
    .concat(CalendarEvents())
    .concat(SsidPopup())
    .concat(NotificationsPopupWindow())
    .concat(NotificationCenter()),
};

