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
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import PopupWindow from "./popupWindow3.js";

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
  if (Sway.active.workspace.name == ws?.name) return "focused";
  else if (ws.urgent) return "urgent";
  return "";
};

const Workspaces = (monitorName) =>
  Widget.Box({
    class_name: "workspaces",
  }).hook(
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
        }
    );

const time = Variable("", {
    poll: [1000, "date +%H:%M"],
});

const intval = 5000;

const cpu = Variable(0, {
    poll: [intval, "top -bn1", out => { 
      const value = out
        .split('\n')
        .find(line => line.includes("%CPU"))
        .split(/\s+/);

      return (!value || value.length < 2) ? 0 : parseFloat(value[1].replaceAll(',', '.'));
    }]
});

const ram = Variable(0, {
    poll: [intval, 'free', out => { 
      const freeValues = out.split('\n')
        .find(line => line.includes('Mem.:'))
        ?.split(/\s+/);

      return (freeValues[2] / freeValues[1]) * 100;
    }],
});

const vars = { cpu, ram, battery: Battery.percent };

const icons = {
   system: {
        cpu: 'org.gnome.SystemMonitor-symbolic',
        ram: 'drive-harddisk-solidstate-symbolic',
    }
}

const Clock = () =>
  Widget.Label({
    class_name: "clock",
  }).bind("label", time);

const date = Variable("", {
    poll: [1000, "date '+%a, %e %b %Y'"],
});

const DateBox = () =>
  Widget.Button({
    class_name: "date",
    onClicked: () => App.toggleWindow("dashboard"),
  }).bind("label", date);

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
            ["enabled", Widget.Icon("preferences-system-notifications-symbolic")],
            ["disabled", Widget.Icon("notifications-disabled-symbolic")],
          ]}).hook(
              Notifications,
              (self) => {
                self.shown = Notifications.dnd ? "disabled" : "enabled";
              },
            ),
        Widget.Label({
          class_name: "emblem",
          label: Notifications
            .bind("notifications")
            .transform(m => m.length.toString())
        }),
      ],
    }),
  });

const VolumeIcon = () => Widget.Stack({
    items: [
      ["101", Widget.Icon("audio-volume-overamplified-symbolic")],
      ["67", Widget.Icon("audio-volume-high-symbolic")],
      ["34", Widget.Icon("audio-volume-medium-symbolic")],
      ["1", Widget.Icon("audio-volume-low-symbolic")],
      ["0", Widget.Icon("audio-volume-muted-symbolic")],
    ]
  }).hook(Audio,
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
  )

const Volume = () =>
  Widget.Button({
    onPrimaryClick: () => App.toggleWindow('sys-status'),
    onSecondaryClick: () =>
      execAsync("pavucontrol"),
    tooltip_text: Audio.bind('speaker').transform(s => `Level: ${(s?.volume * 100).toFixed(0)}%`),
    child: Widget.Box({
      class_name: "volume",
      children: [
        VolumeIcon()
      ],
    })
  });

const Mic = () =>
  Widget.Button({
    onPrimaryClick: () => App.toggleWindow('sys-status'),
    onSecondaryClick: () =>
      execAsync("pavucontrol"),
    child: Widget.Box({
      class_name: "mic",
      children: [
        Widget.Stack({
          items: [
            // tuples of [string, Widget]
            ["unmuted", Widget.Icon("microphone-sensitivity-high-symbolic")],
            ["muted", Widget.Icon("microphone-sensitivity-muted-symbolic")],
          ]})
        .hook(Audio,
          (self) => {
            if (!Audio.microphone) return;

            self.shown = Audio.microphone.stream.isMuted
              ? "muted"
              : "unmuted";
          },
          "microphone-changed"
        )
      ],
    })
    .hook(Audio,
      (self) => {
        if (!Audio.microphone) return;

        self.tooltip_text = Audio.microphone.stream.isMuted
          ? "Mudo"
          : `Level: ${(Audio.microphone.volume *100).toFixed(0)}`;
      },
      "microphone-changed"
    )
  });

const BatteryLabel = () =>
  Widget.Button({
    class_name: "battery",
    tooltip_text: Battery.bind('percent').transform(p => `Level: ${p}%`),
    onClicked: () => App.toggleWindow('sys-status'),
    child: 
      Widget.Icon({
          icon: Battery.bind('icon_name')
      }),
  });

const SysTray = () =>
  Widget
    .Box()
    .bind(
      'children',
      SystemTray,
      'items',
      (sysItems) => {
        return sysItems.map((item) => {
          return Widget.Button({
            child: Widget.Icon().bind("icon", item, "icon"),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
          })
          .bind("tooltip-markup", item, "tooltip-markup");
        });
      },
  );

const WifiIndicator = () =>
  Widget.Box({
    tooltip_text: Network.bind('wifi').transform(w => `${w.ssid} (${w.strength}%)`),
    child: Widget
      .Icon()
      .bind('icon', Network, 'wifi',
        (wifi) => wifi?.iconName)
  });

const WiredIndicator = () =>
  Widget
    .Icon()
    .bind('icon', Network, 'wired',
      (wired) => wired?.iconName);

const NetworkIcon = () =>
  Widget.Stack({
      items: [
        ["wifi", WifiIndicator()],
        ["wired", WiredIndicator()],
      ]})
    .bind("shown", Network, "primary", (p) => p || "wifi")

const NetworkIndicator = () =>
  Widget.Button({
    onClicked: () => App.toggleWindow('sys-status'),
    child: NetworkIcon()
  })

const vpnSessionList = Variable("", {
    poll: [60000, "openvpn3 sessions-list"],
});

const VpnIndicator = () =>
  Widget.Icon({
    icon: "network-vpn-symbolic",
    visible: vpnSessionList
      .bind()
      .transform(out => !out.includes("No sessions available"))
  })


// const memoryIcon = "\ue266";
const Cpu = () =>
  Widget.Button({
    onClicked: () => App.toggleWindow('sys-status'),
    child: Widget.Icon("speedometer-symbolic"),
    tooltip_text: cpu.bind().transform(v => `CPU: ${v.toFixed(2)}%`)
  });

const Memory = () =>
  Widget.Button({
    on_clicked: () => App.toggleWindow('sys-status'),
    child: Widget.Icon("media-flash-symbolic"),
    tooltip_text: ram.bind().transform(v => `RAM: ${v.toFixed(2)}%`)
  });

const githubIcon = "\uf113";
const ghPrStatusOutput = Variable("", {
  poll: [120000, "/home/rodrigosilva/.config/ags/github-pr.sh"],
});

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
            [
              "error",
              Widget.Icon({
                icon: "dialog-error-symbolic",
                class_name: "emblem error",
              }),
            ],
          ],
          shown: ghPrStatusOutput.bind().transform(out => {
            if (!out) return "error";
            // TODO: Move this code to its Service
            const outNoColor = out.replaceAll("\u000d", ""); // Remove color
            const jsonOutput = JSON.parse(outNoColor);
            return jsonOutput.count ? "PendingPR" : "NoPending";
          })
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
      class_name: "calender-events-container"
    }).hook(
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
          })
        })
      })
  });

const CalendarNextEvent = () =>
  Widget.Button({
    onClicked: () => App.toggleWindow("calendar-events"),
    child: Widget.Box({
      spacing: 5
    }).hook(
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
    ),
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
    setup: (self) => self.hook(Sway, (_, value) => {
      // Close notifications when open application
      for (let pendingNotification of Notifications.notifications) {
        if (pendingNotification.app_name.toUpperCase() == value?.toUpperCase()) pendingNotification.close();
      }
    }, "window-changed"),
    child: Widget.Box({
      children: [
        Widget.EventBox({
          hexpand: true,
        }).on("button-press-event", 
          () => App.closeWindow("notification-center")),
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



/**
 * @param {'cpu' | 'ram' } type
 * @param {string} title
 * @param {string} unit
 */
const SysProgress = (type, title, unit) => Widget.Box({
    class_name: `circular-progress-box ${type}`,
    vertical: true,          
    hexpand: true,
    tooltip_text: vars[type].bind('value')
        .transform(v => `${title}: ${v.toFixed(2)}${unit}`),
    children: [ 
      Widget.Label(title),
      Widget.CircularProgress({
        hexpand: true,
        class_name: `circular-progress ${type}`,
        child: 
          Widget.Icon({
            icon: icons.system[type],
            class_name: 'icon'
          }),
        start_at: 0.75,
        value: vars[type].bind().transform(v => v / 100),
        rounded: 29,
      }),
      Widget.Label({ 
        label: vars[type]
          .bind()
          .transform(v => v.toFixed(2) + "%"),
        class_name: 'values'
      })
    ]
});



const BatteryProgress = () => Widget.Box({
    class_name: `circular-progress-box battery`,
    vertical: true,          
    hexpand: true,
    tooltip_text: Battery.bind('percent')
        .transform(v => `Battery Level: ${v.toFixed(0)}%`),
    children: [ 
      Widget.Label('Battery'),
      Widget.CircularProgress({
        hexpand: true,
        class_name: `circular-progress battery`,
        child: 
          Widget.Icon({
            icon: Battery.bind('icon_name'),
            class_name: 'icon'
          }),
        start_at: 0.75,
        value: Battery.bind('percent').transform(v => v / 100),
        rounded: 29,
      }),
      Widget.Label({ 
        label: Battery.bind('percent')
          .transform(v => v.toFixed(0) + "%"),
        class_name: 'values'
      })
    ]
});

const VolumeSlider = (type = 'speaker') => Widget.Slider({
  hexpand: true,
  drawValue: false,
  onChange: ({ value }) => Audio.speaker.volume = value,
  class_name: Audio.bind('speaker').transform(s => s.stream.isMuted ? "muted" : ""),
  value: Audio.bind('speaker').transform(s => `${s.volume}`)
})

// const VolumeSlider = () => Widget.ProgressBar({
//   hexpand: true,
//   value: Audio.bind('speaker').transform(s => `${s.volume}`),
//   class_name: Audio.bind('speaker').transform(s => s.stream.isMuted ? "muted" : "")
// })

const SysStatusWindow = () => PopupWindow({
  name: 'sys-status',
  anchor:["top", "right"],
  transition: 'slide_down',
  class_name: 'status-window',
  child: Widget.Box({
    class_name: "default-box",
    vertical: true,
    spacing: 5,
    children: [
      Widget.Box({
        children: [
          SysProgress('cpu', 'CPU', '%'),
          SysProgress('ram', 'RAM', '%'),
          BatteryProgress()
        ]
      }),
      Widget.Box({
        spacing: 12,
        tooltip_text: Network.bind('wifi').transform(w => `Strengh: ${w.strength}%`),
        children: [
          NetworkIcon(),
          Widget.Label({
            label: 
              Network.bind('wifi').transform(w => w.ssid)
          }),
        ]
      }),
      Widget.Box({
        children: [
          VolumeIcon(),
          VolumeSlider(),
          Widget.Button({
            child: Widget.Icon('settings-app-symbolic'),
            onClicked: () =>
              execAsync("pavucontrol"),
          })
        ]
      })
    ]
  })
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
      Cpu(),
      Memory(),
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

const Calendar = () =>
  PopupWindow({
    name: "dashboard",
    anchor: ['top'],
    transition: 'slide_down',
    child: Widget.Box({
      class_name: "dashboard",
      children: [Widget.Calendar()],
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
    .concat(NotificationsPopupWindow())
    .concat(SysStatusWindow())
    .concat(NotificationCenter()),
};


