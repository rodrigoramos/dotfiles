// importing 
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import Sway from './sway.js';

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, just make it a function
// then you can use it by calling simply calling it

const getWorkspaceClassName = (ws) => {
  if (Sway.active.workspace.name == ws.name)
    return 'focused';
  else if (ws.urgent){
    return 'urgent';
  }

  return '';
}

const Workspaces = (monitor) => Widget.Box({
    className: 'workspaces',
    connections: [[Sway.active.workspace, self => {
        const currentMonitors = Sway.monitors.filter(m => m.index == monitor)?.map(m => m.name);
        const currentMonitorName = currentMonitors && currentMonitors.length ? currentMonitors[0]: null;

        self.children = Sway.workspaces
          .filter(w => !currentMonitorName || w.output === currentMonitorName)
          .map(i => {
            return Widget.Button({
              onClicked: () => execAsync(`swaymsg workspace ${i.name}`),
              child: Widget.Label(`${i.name}`),
              className: getWorkspaceClassName(i)
            
          })});
    }]],
});

const Clock = () => Widget.Label({
    className: 'clock',
    connections: [
        // this is bad practice, since exec() will block the main event loop
        // in the case of a simple date its not really a problem
        // [1000, self => self.label = exec('date "+%H:%M:%S %b %e."')],

        // this is what you should do
        [1000, self => execAsync(['date', '+%H:%M:%S %b %e'])
            .then(date => self.label = date).catch(console.error)],
    ],
});

// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
const Notification = () => Widget.Box({
    className: 'notification',
    children: [
        Widget.Icon({
            icon: 'preferences-system-notifications-symbolic',
            connections: [
                [Notifications, self => self.visible = Notifications.popups.length > 0],
            ],
        }),
        Widget.Label({
            connections: [[Notifications, self => {
                self.label = Notifications.popups[0]?.summary || '';
            }]],
        }),
    ],
});

const Media = () => Widget.Button({
    className: 'media',
    onPrimaryClick: () => Mpris.getPlayer('')?.playPause(),
    onScrollUp: () => Mpris.getPlayer('')?.next(),
    onScrollDown: () => Mpris.getPlayer('')?.previous(),
    child: Widget.Label({
        connections: [[Mpris, self => {
            const mpris = Mpris.getPlayer('');
            // mpris player can be undefined
            if (mpris)
                self.label = `${mpris.trackArtists.join(', ')} - ${mpris.trackTitle}`;
            else
                self.label = 'Nothing is playing';
        }]],
    }),
});

const Volume = () => Widget.Box({
    className: 'volume',
    style: 'min-width: 180px',
    children: [
        Widget.Stack({
            items: [
                // tuples of [string, Widget]
                ['101', Widget.Icon('audio-volume-overamplified-symbolic')],
                ['67', Widget.Icon('audio-volume-high-symbolic')],
                ['34', Widget.Icon('audio-volume-medium-symbolic')],
                ['1', Widget.Icon('audio-volume-low-symbolic')],
                ['0', Widget.Icon('audio-volume-muted-symbolic')],
            ],
            connections: [[Audio, self => {
                if (!Audio.speaker)
                    return;

                if (Audio.speaker.isMuted) {
                    self.shown = '0';
                    return;
                }

                const show = [101, 67, 34, 1, 0].find(
                    threshold => threshold <= Audio.speaker.volume * 100);

                self.shown = `${show}`;
            }, 'speaker-changed']],
        }),
        Widget.Slider({
            hexpand: true,
            drawValue: false,
            onChange: ({ value }) => Audio.speaker.volume = value,
            connections: [[Audio, self => {
                self.value = Audio.speaker?.volume || 0;
            }, 'speaker-changed']],
        }),
    ],
});

const BatteryLabel = () => Widget.Box({
    className: 'battery',
    children: [
        Widget.Icon({
            connections: [[Battery, self => {
                self.icon = `battery-level-${Math.floor(Battery.percent / 10) * 10}-symbolic`;
            }]],
        }),
        Widget.ProgressBar({
            valign: 'center',
            connections: [[Battery, self => {
                if (Battery.percent < 0)
                    return;

                self.fraction = Battery.percent / 100;
            }]],
        }),
    ],
});

const SysTray = () => Widget.Box({
    connections: [[SystemTray, self => {
        self.children = SystemTray.items.map(item => Widget.Button({
            child: Widget.Icon({ binds: [['icon', item, 'icon']] }),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
            binds: [['tooltip-markup', item, 'tooltip-markup']],
        }));
    }]],
});

// layout of the bar
const Left = (monitor) => Widget.Box({
    children: [
        Workspaces(monitor),
        Clock(),
    ],
});

const Center = () => Widget.Box({
    children: [
        Media(),
        Notification(),
    ],
});

const Right = () => Widget.Box({
    halign: 'end',
    children: [
        Volume(),
        BatteryLabel(),
        SysTray(),
    ],
});

const Bar = ({ monitor } = {}) => Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    className: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusive: true,
    child: Widget.CenterBox({
        startWidget: Left(monitor),
        centerWidget: Center(),
        endWidget: Right(),
    }),
})

// exporting the config so ags can manage the windows
export default {
    style: App.configDir + '/style.css',
    windows: [
        // Bar(),

        // you can call it, for each monitor
        Bar({ monitor: 0 }),
        Bar({ monitor: 1 }),
        Bar({ monitor: 2 })
    ],
};
