import GLib from "gi://GLib";
import Gio from "gi://Gio";
import Service from "resource:///com/github/Aylur/ags/service.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

class Active extends Service {
  updateProperty(prop, value) {
    super.updateProperty(prop, value);
    this.emit("changed");
  }
}

class ActiveWorkspace extends Active {
  static {
    Service.register(
      this,
      {},
      {
        name: ["string"],
      }
    );
  }

  _name = "";

  get name() {
    return this._name;
  }
}

class Actives extends Service {
  static {
    Service.register(
      this,
      {},
      {
        monitor: ["string"],
        workspace: ["string"],
      }
    );
  }

  constructor() {
    super();

    [this._workspace].forEach((s) =>
      s.connect("changed", () => this.emit("changed"))
    );

    ["name"].forEach((attr) =>
      this._workspace.connect(`notify::${attr}`, () =>
        this.changed("workspace")
      )
    );
  }

  _monitor = "";
  _workspace = new ActiveWorkspace();

  get monitor() {
    return this._monitor;
  }
  get workspace() {
    return this._workspace;
  }
}

class Sway extends Service {
  static {
    Service.register(
      this,
      {
        "urgent-window": ["string"],
        submap: ["string"],
        "workspace-added": ["string"],
        "workspace-removed": ["string"],
      },
      {
        active: ["jsobject"],
        monitors: ["jsobject"],
        workspaces: ["jsobject"],
      }
    );
  }

  _active;
  _monitors = new Map();
  _workspaces;
  _decoder = new TextDecoder();

  get active() {
    return this._active;
  }
  get monitors() {
    return Array.from(this._monitors.values());
  }
  get workspaces() {
    return Array.from(this._workspaces.values());
  }

  getMonitor(id) {
    return this._monitors.get(id);
  }
  getWorkspace(id) {
    return this._workspaces.get(id);
  }

  constructor() {
    super();
    this._active = new Actives();
    this._monitors = new Map();
    this._workspaces = new Map();
    this._syncMonitors();
    this._syncWorkspaces();

    const command = "/usr/bin/swaymsg";
    const args = ["-m", "-t", "subscribe", '["workspace"]'];

    try {
      const [success, _, __, out_fd] = GLib.spawn_async_with_pipes(
        null,
        [command].concat(args),
        null,
        GLib.SpawnFlags.SEARCH_PATH,
        null
      );

      if (!success) {
        console.error(
          "Error trying to listen to Sway changes (swaymsg -t subscribe)."
        );
        return;
      }

      const stdoutPipe = new Gio.DataInputStream({
        base_stream: new Gio.UnixInputStream({ fd: out_fd }),
      });
      this._watchSubscribeCommand(stdoutPipe);
    } catch (err) {
      console.error(err);
    }

    this._active.connect("changed", () => this.emit("changed"));
    ["monitor", "workspace"].forEach((active) =>
      this._active.connect(`notify::${active}`, () => this.changed("active"))
    );
  }

  _watchSubscribeCommand(stdoutPipe) {
    stdoutPipe.read_line_async(GLib.PRIORITY_LOW, null, (sourceObject, res) => {
      const [line, length] = sourceObject.read_line_finish(res);
      if (length > 0) {
        try {
          const decodedLine = this._decoder.decode(line);
          var output = JSON.parse(decodedLine);
          this._onEvent(output);
        } catch (err) {
          console.error("Error reading swaymsg subscribe command", err);
        }
      }

      this._watchSubscribeCommand(stdoutPipe);
    });
  }

  async _syncMonitors() {
    try {
      const monitors = await execAsync("swaymsg -r -t get_outputs");
      this._monitors = new Map();
      const json = JSON.parse(monitors);
      let focusedData = null;
      json.forEach((monitor, index) => {
        this._monitors.set(monitor.id, { ...monitor, index });
        if (monitor.focused) {
          focusedData = {
            monitorName: monitor.name,
            workspaceName: monitor.current_workspace,
          };
        }
      });

      if (focusedData) {
        this._active.updateProperty("monitor", focusedData.monitorName);
        this._active.workspace.updateProperty(
          "name",
          focusedData.workspaceName
        );
      }

      this.notify("monitors");
    } catch (error) {
      console.error(error);
    }
  }

  async _syncWorkspaces() {
    try {
      const workspaces = await execAsync("swaymsg -r -t get_workspaces");
      this._workspaces = new Map();
      const json = JSON.parse(workspaces);
      json.forEach((ws) => {
        this._workspaces.set(ws.id, ws);
      });
      this.notify("workspaces");
    } catch (error) {
      console.error(error);
    }
  }

  _updateWorkspace(ws) {
    this._workspaces.set(ws.id, ws);

    if (ws.focused) {
      this._active.updateProperty("monitor", ws.output);
      this._active.workspace.updateProperty("name", ws.name);
    } else {
      this._active.workspace.emit("changed");
    }

    this.notify("workspaces");
  }

  async _onEvent(event) {
    if (!event) return;

    const { change } = event;

    switch (change) {
      case "focus":
        if (event.old) this._updateWorkspace(event.old);

        this._updateWorkspace({ ...event.current, focused: true });
        break;
      case "init":
        await this._syncWorkspaces();
        await this._syncMonitors();
        this.emit("workspace-added", event);
        break;
      case "empty":
        await this._syncWorkspaces();
        await this._syncMonitors();
        this.emit("workspace-removed", event);
        break;
      case "move":
      case "reload":
        await this._syncWorkspaces();
        await this._syncMonitors();
        break;
      case "urgent":
        this._updateWorkspace(event.current);
        this.emit("urgent-window", event);
      default:
        break;
    }

    this.emit("changed");
  }
}

export default new Sway();
