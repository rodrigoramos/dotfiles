import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import KhalService from "./khalService.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import SystemTray from "resource:///com/github/Aylur/ags/service/systemtray.js";
import PopupWindowWrapper from "../.widgethacks/popupWindowWrapper.js";

import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

const dispatch = (ws) => execAsync(`hyprctl dispatch workspace ${ws}`);

const markupTransform = (unsafe) => {
  if (!unsafe) return unsafe;

  return unsafe
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;");
};

const workspacesIcons = [
  " ",
  " ",
  " ",
  "󰒱 ",
  "󰊻 ",
  "󱓧 ",
  "7",
  "8",
  " ",
  "10",
];

const Workspaces = (monitorKey) =>
  Widget.Box({
    class_name: "workspaces",
    spacing: 12,
    children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
      Widget.Button({
        attribute: i,
        label: `${workspacesIcons[i - 1]}`,
        onClicked: () => dispatch(i),
      })
    ),
    setup: (self) =>
      self.hook(hyprland, () => {
        const currentMonitorName = hyprland.monitors[monitorKey]?.name;

        self.children.forEach((btn) => {
          btn.visible = hyprland.workspaces.some(
            (ws) =>
              ws.id === btn.attribute &&
              (!currentMonitorName || ws.monitor === currentMonitorName)
          );

          btn.hook(
            hyprland,
            (self, clientAddress) => {
              if (!clientAddress) return;

              const client = hyprland.getClient(clientAddress);
              if (client.workspace.id == self.attribute) {
                self.class_name = "urgent";
              }
            },
            "urgent-window"
          );

          btn.hook(
            hyprland,
            (self, eventName, eventData) => {
              let workspace;

              switch (eventName) {
                case "focusedmon":
                  const [_, eventWorkspace] = eventData.split(",");
                  workspace = parseInt(eventWorkspace, 10);
                  break;
                case "workspace":
                  workspace = parseInt(eventData, 10);
                  break;
                default:
                  return;
              }

              self.class_name = self.attribute === workspace ? "focused" : "";
            },
            "event"
          );
        });
      }),
    // }).hook(hyprland, (self, clientAddress) => {
    //   if (!clientAddress) return;

    //   const client = hyprland.getClient(clientAddress);
    //   self.children[client.workspace.id].class_name = "urgent";

    //   console.log(self.children[client.workspace.id].class_name);
    //   self.children[client.workspace.id].visible = false;
    // }, "urgent-window")
  });
const time = Variable("", {
  poll: [1000, "date +%H:%M"],
});

const intval = 5000;

const cpu = Variable(0, {
  poll: [
    intval,
    "top -bn1",
    (out) => {
      const value = out
        .split("\n")
        .find((line) => line.includes("%Cpu(s)"))
        .split(/\s+/);

      return !value || value.length < 2
        ? 0
        : parseFloat(value[1].replaceAll(",", "."));
    },
  ],
});

const ram = Variable(0, {
  poll: [
    intval,
    "free",
    (out) => {
      const freeValues = out
        .split("\n")
        .find((line) => line.includes("Mem:"))
        ?.split(/\s+/);

      return (freeValues[2] / freeValues[1]) * 100;
    },
  ],
});

const vars = { cpu, ram, battery: Battery.percent };

const icons = {
  system: {
    cpu: "org.gnome.SystemMonitor-symbolic",
    ram: "drive-harddisk-solidstate-symbolic",
  },
};

const Calendar = () =>
  PopupWindowWrapper({
    name: "calendar",
    anchor: ["top"],
    transition: "slide_down",
    class_name: "calendar",
    child: Widget.Box({
      children: [Widget.Calendar()],
    }),
  });

const Clock = () =>
  Widget.Button({
    class_name: "clock",
    onClicked: () => execAsync("swaync-client -t -sw"),
  }).bind("label", time);

const date = Variable("", {
  poll: [1000, "date '+%a, %e %b %Y'"],
});

const DateBox = () =>
  Widget.Button({
    class_name: "date",
    onClicked: () => App.toggleWindow("calendar"),
  }).bind("label", date);

const CalendarEvents = () =>
  PopupWindowWrapper({
    name: "calendar-events",
    anchor: ["top", "right"],
    transition: "slide_down",
    child: Widget.Box({
      vertical: true,
      class_name: "calendar-events-container",
    }).hook(KhalService, (self) => {
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
                  }: ${markupTransform(event.title)}${event.repeatSymbol}`,
                  justification: "left",
                  xalign: 0,
                  useMarkup: true,
                })
              ),
            }),
          ],
        });
      });
    }),
  });

const CalendarNextEvent = () =>
  Widget.Button({
    onClicked: () => App.toggleWindow("calendar-events"),
    child: Widget.Box({
      spacing: 5,
    }).hook(KhalService, (self) => {
      const nextEvent = !KhalService.calendarEvents?.length
        ? null
        : KhalService.calendarEvents[0];

      self.children = [
        Widget.Icon("x-office-calendar-symbolic"),
        Widget.Label({
          useMarkup: true,
          label: !nextEvent
            ? "No Next Event"
            : `${nextEvent.startTime}-${nextEvent.endTime}: ${markupTransform(
                nextEvent.title
              )}${nextEvent.repeatSymbol}`,
        }),
      ];
    }),
  });

const githubIcon = "\uf113";
const ghPrStatusOutput = Variable("", {
  poll: [120000, "/home/rodrigosilva/git/dotfiles/ags/github-pr.sh"],
});

const GithubPR = () =>
  Widget.Button({
    onClicked: () =>
      execAsync("xdg-open https://github.com/pulls/review-requested"),
    child: Widget.Box({
      children: [
        Widget.Label(githubIcon),
        Widget.Stack({
          children: {
            NoPending: Widget.Icon({
              icon: "emblem-ok-symbolic",
              class_name: "emblem ok",
            }),
            PendingPR: Widget.Icon({
              icon: "dialog-warning-symbolic",
              class_name: "emblem nok",
            }),
            error: Widget.Icon({
              icon: "dialog-error-symbolic",
              class_name: "emblem error",
            }),
          },
          shown: ghPrStatusOutput.bind().transform((out) => {
            if (!out) return "error";
            // TODO: Move this code to its Service
            const outNoColor = out.replaceAll("\u000d", ""); // Remove color
            const jsonOutput = JSON.parse(outNoColor);
            return jsonOutput.count ? "PendingPR" : "NoPending";
          }),
        }),
      ],
    }),
  });

const Cpu = () =>
  Widget.Button({
    onClicked: () => execAsync("swaync-client -t -sw # swayNC panel"),
    child: Widget.Icon("speedometer-symbolic"),
    tooltip_text: cpu.bind().transform((v) => `CPU: ${v.toFixed(2)}%`),
  });

const Memory = () =>
  Widget.Button({
    onClicked: () => execAsync("swaync-client -t -sw # swayNC panel"),
    child: Widget.Icon("media-flash-symbolic"),
    tooltip_text: ram.bind().transform((v) => `RAM: ${v.toFixed(2)}%`),
  });

const WifiIndicator = () =>
  Widget.Box({
    tooltip_text: Network.bind("wifi").transform(
      (w) => `${w.ssid} (${w.strength}%)`
    ),
    child: Widget.Icon().bind(
      "icon",
      Network,
      "wifi",
      (wifi) => wifi?.iconName
    ),
  });

const WiredIndicator = () =>
  Widget.Icon().bind("icon", Network, "wired", (wired) => wired?.iconName);

const NetworkIcon = () =>
  Widget.Stack({
    children: {
      wifi: WifiIndicator(),
      wired: WiredIndicator(),
    },
  }).bind("shown", Network, "primary", (p) => p || "wifi");

const NetworkIndicator = () =>
  Widget.Button({
    onClicked: () => execAsync("swaync-client -t -sw # swayNC panel"),
    child: NetworkIcon(),
  });

const vpnSessionList = Variable("", {
  poll: [60000, "openvpn3 sessions-list"],
});

const VpnIndicator = () =>
  Widget.Icon({
    icon: "network-vpn-symbolic",
    visible: vpnSessionList
      .bind()
      .transform((out) => !out.includes("No sessions available")),
  });

const BatteryLabel = () =>
  Widget.Button({
    class_name: "battery",
    tooltip_text: Battery.bind("percent").transform((p) => `Level: ${p}%`),
    onClicked: () => execAsync("swaync-client -t -sw # swayNC panel"),
    child: Widget.Icon({
      icon: Battery.bind("icon_name"),
    }),
  });

const VolumeIcon = () =>
  Widget.Stack({
    children: {
      101: Widget.Icon("audio-volume-overamplified-symbolic"),
      67: Widget.Icon("audio-volume-high-symbolic"),
      34: Widget.Icon("audio-volume-medium-symbolic"),
      1: Widget.Icon("audio-volume-low-symbolic"),
      0: Widget.Icon("audio-volume-muted-symbolic"),
    },
  }).hook(
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
    "speaker-changed"
  );

const Volume = () =>
  Widget.Button({
    onPrimaryClick: () => execAsync("swaync-client -t -sw # swayNC panel"),
    onSecondaryClick: () => execAsync("pavucontrol"),
    tooltip_text: Audio.bind("speaker").transform(
      (s) => `Level: ${(s?.volume * 100).toFixed(0)}%`
    ),
    child: Widget.Box({
      class_name: "volume",
      children: [VolumeIcon()],
    }),
  });

const Mic = () =>
  Widget.Button({
    onPrimaryClick: () => execAsync("swaync-client -t -sw # swayNC panel"),
    onSecondaryClick: () => execAsync("pavucontrol"),
    child: Widget.Box({
      class_name: "mic",
      children: [
        Widget.Stack({
          children: {
            unmuted: Widget.Icon("microphone-sensitivity-high-symbolic"),
            muted: Widget.Icon("microphone-sensitivity-muted-symbolic"),
          },
        }).hook(
          Audio,
          (self) => {
            if (!Audio.microphone) return;

            self.shown = Audio.microphone.stream.isMuted ? "muted" : "unmuted";
          },
          "microphone-changed"
        ),
      ],
    }).hook(
      Audio,
      (self) => {
        if (!Audio.microphone) return;

        self.tooltip_text = Audio.microphone.stream.isMuted
          ? "Mudo"
          : `Level: ${(Audio.microphone.volume * 100).toFixed(0)}`;
      },
      "microphone-changed"
    ),
  });

const SysTray = () =>
  Widget.Box().bind("children", SystemTray, "items", (sysItems) => {
    return sysItems.map((item) => {
      return Widget.Button({
        child: Widget.Icon().bind("icon", item, "icon"),
        onPrimaryClick: (_, event) => item.activate(event),
        onSecondaryClick: (_, event) => item.openMenu(event),
      }).bind("tooltip-markup", item, "tooltip-markup");
    });
  });

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
      // Notification(),
      SysTray(),
      Clock(),
    ],
  });

export const Bar = (monitorId, monitorName) =>
  Widget.Window({
    name: `bar-${monitorName}`, // name has to be unique
    class_name: "bar",
    monitor: monitorId,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(monitorName),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });

export const PopupWindows = [Calendar(), CalendarEvents()];
