import Service from "resource:///com/github/Aylur/ags/service.js";
import { timeout, execAsync } from "resource:///com/github/Aylur/ags/utils.js";

const twoMinInMs = 120000;
class KhalService extends Service {
  static {
    Service.register(
      this,
      {
        eventsChanged: ["jsobject"],
      },
      {
        calendarEvents: ["jsobject", "rw"],
        eventsByDay:  ["jsobject", "rw"],
      }
    );
  }

  _calendarEvents = [];

  get calendarEvents() {
    return this._calendarEvents;
  }

  get eventsByDay() {
    return this.calendarEvents.reduce((eventsByDay, event) => {
      const indexOfCurrentDay = eventsByDay.findIndex((item) => item.day == event.startDate);

      if (indexOfCurrentDay == -1) {
        eventsByDay.push({ day: event.startDate, events: [event] });
      } else {
        eventsByDay[indexOfCurrentDay].events.push(event);
      }

      return eventsByDay;
    }, []);
  }

  constructor() {
    super();

    this._refresh();
    this._scheduleRefresh();
  }

  _scheduleRefresh() {
    timeout(twoMinInMs, () => {
      this._refresh();
      this._scheduleRefresh();
    });
  }

  _refresh() {
    execAsync("python3 /home/rodrigosilva/.config/ags/waybar-khal.py")
      .then((output) => {
        const jsonOutput = JSON.parse(output);
        this._calendarEvents = jsonOutput?.length ? jsonOutput : [];

        this.emit("eventsChanged", this._calendarEvents);
        this.notify("calendarEvents");
        this.notify("eventsByDay");
      })
      .catch(console.error);
  }

  connect(event = "eventsChanged", callback) {
    return super.connect(event, callback);
  }
}

export default new KhalService();
