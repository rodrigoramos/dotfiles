pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Upcoming (not yet started) khal events for the next few days.
 */
Singleton {
    id: root

    readonly property int daysAhead: 3
    readonly property var ptBR: Qt.locale("pt_BR")

    // [{ date: Date, start, end, recurring, allDay, title }] in chronological order
    property var events: []

    // Next timed event (all-day events are skipped), or null
    readonly property var next: events.find(e => !e.allDay) ?? null

    // Events grouped per day: [{ label, events }]
    readonly property var days: {
        const groups = []
        for (const e of events) {
            const label = root.dayLabel(e.date)
            if (groups.length === 0 || groups[groups.length - 1].label !== label)
                groups.push({ label: label, events: [] })
            groups[groups.length - 1].events.push(e)
        }
        return groups
    }

    function daysFromToday(date) {
        const today = new Date()
        today.setHours(0, 0, 0, 0)
        const day = new Date(date.getFullYear(), date.getMonth(), date.getDate())
        return Math.round((day - today) / 86400000)
    }

    function dayLabel(date) {
        const diff = root.daysFromToday(date)
        if (diff === 0) return "Hoje"
        if (diff === 1) return "Amanhã"
        return root.ptBR.toString(date, "ddd dd/MM").replace(/\./g, "")
    }

    // "qui " for events after today, "" for today
    function shortDayPrefix(date) {
        return root.daysFromToday(date) === 0 ? "" : root.ptBR.toString(date, "ddd").replace(/\./g, "") + " "
    }

    // Unit separator between fields; record separator marks khal's day headers.
    // Titles can contain any printable character (e.g. "|").
    readonly property string sep: "\x1f"
    readonly property string daySep: "\x1e"

    function parseDate(s) {
        const [d, m, y] = s.split("/").map(Number)
        return new Date(y, m - 1, d)
    }

    function dateKey(date) {
        return Qt.formatDate(date, "yyyy-MM-dd")
    }

    // Each event is attributed to the day header it's listed under, so
    // multi-day events show up on every day they span
    function parse(text) {
        const events = []
        let day = null
        for (const line of text.split("\n")) {
            if (line.startsWith(root.daySep)) {
                day = root.parseDate(line.slice(1).trim())
                continue
            }
            if (!day || !line.includes(root.sep)) continue
            const [start, end, repeat, allDay, ...title] = line.split(root.sep)
            events.push({
                date: day,
                start: start,
                end: end,
                recurring: repeat.trim() !== "",
                allDay: allDay === "True",
                title: title.join(root.sep).trim()
            })
        }
        return events
    }

    function khalCommand(extraArgs) {
        return ["khal", "list", "--day-format", root.daySep + "{date-long}",
                "--format", ["{start-time}", "{end-time}", "{repeat-symbol}", "{all-day}", "{title}"].join(root.sep)]
            .concat(extraArgs)
    }

    Process {
        id: khalProc
        command: root.khalCommand(["--notstarted", "now", root.daysAhead + "d"])
        stdout: StdioCollector {
            onStreamFinished: root.events = root.parse(this.text)
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: khalProc.running = true
    }

    // Calendar: events per day ("yyyy-MM-dd" -> [event]), cached across months.
    // khal takes a few seconds to expand recurring events over a month, so the
    // visible month and its neighbours are loaded in the background and kept.
    property var rangeEvents: ({})
    property var loadedAt: ({})   // grid start key -> Date.now() of last load
    property var inFlight: ({})   // grid start key -> true while loading
    readonly property int cacheTtl: 10 * 60 * 1000

    function eventsOn(date) {
        return root.rangeEvents[root.dateKey(date)] ?? []
    }

    // First day of the 6-week grid shown for a month
    function gridStart(year, month) {
        const first = new Date(year, month, 1)
        const offset = (first.getDay() - root.ptBR.firstDayOfWeek + 7) % 7
        return new Date(first.getFullYear(), first.getMonth(), 1 - offset)
    }

    // The visible month is always refreshed; neighbours only when missing or stale
    function loadMonth(year, month) {
        root.loadRange(root.gridStart(year, month), true)
        root.loadRange(root.gridStart(year, month + 1), false)
        root.loadRange(root.gridStart(year, month - 1), false)
    }

    function loadRange(first, force) {
        const key = root.dateKey(first)
        if (root.inFlight[key]) return
        if (!force && Date.now() - (root.loadedAt[key] ?? 0) < root.cacheTtl) return
        root.inFlight[key] = true
        rangeLoader.createObject(root, { range: { first: first, days: 42, key: key } })
    }

    function storeRange(range, events) {
        const merged = Object.assign({}, root.rangeEvents)
        for (let i = 0; i < range.days; i++) {
            const d = new Date(range.first.getFullYear(), range.first.getMonth(), range.first.getDate() + i)
            delete merged[root.dateKey(d)]
        }
        for (const e of events) {
            const key = root.dateKey(e.date)
            if (!merged[key]) merged[key] = []
            merged[key].push(e)
        }
        root.rangeEvents = merged
        root.loadedAt = Object.assign({}, root.loadedAt, { [range.key]: Date.now() })
    }

    // One process per range, so each result is stored with its own range
    Component {
        id: rangeLoader

        Process {
            id: loader
            required property var range
            command: root.khalCommand([Qt.formatDate(loader.range.first, "dd/MM/yyyy"), loader.range.days + "d"])
            running: true
            stdout: StdioCollector {
                onStreamFinished: root.storeRange(loader.range, root.parse(this.text))
            }
            onExited: {
                delete root.inFlight[loader.range.key]
                loader.destroy()
            }
        }
    }

    // Preload the current month so the calendar opens with data
    Component.onCompleted: {
        const today = new Date()
        root.loadMonth(today.getFullYear(), today.getMonth())
    }
}
