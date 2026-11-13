//@ pragma UseQApplication
//
import Quickshell
import Quickshell.I3
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Quickshell.Widgets as QsWidgets // Alias for clarity
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Scope {
  id: root

  // System data
  property int cpuUsage: 0
  property int memUsage: 0
  property real lastCpuIdle: 0
  property real lastCpuTotal: 0

  // Theme
  property color colBg: "#1a1b26"
  property color colFg: "#a9b1d6"
  property color colMuted: "#444b6a"
  property color colCyan: "#0db9d7"
  property color colBlue: "#7aa2f7"
  property color colYellow: "#e0af68"
  property color colRed: "#f7768e"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  component BarText: Text {
    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
  }

  // Glyph boxed by its ink bounds, since Nerd Font icons often overflow their
  // advance width. sizeHint reserves room for the widest variant so the layout
  // doesn't shift when the icon changes.
  component BarIcon: Item {
    id: barIcon
    property string icon
    property string sizeHint: icon
    property color color

    implicitWidth: Math.ceil(hintMetrics.tightBoundingRect.width)
    implicitHeight: glyph.height

    TextMetrics { id: hintMetrics; font: glyph.font; text: barIcon.sizeHint }
    TextMetrics { id: iconMetrics; font: glyph.font; text: barIcon.icon }

    BarText {
      id: glyph
      x: (barIcon.width - iconMetrics.tightBoundingRect.width) / 2 - iconMetrics.tightBoundingRect.x
      text: barIcon.icon
      color: barIcon.color
    }
  }

  // Icon + value with a constant visual gap
  component BarStat: Row {
    id: stat
    property string icon
    property string value
    property color color
    spacing: 6

    BarIcon {
      icon: stat.icon
      color: stat.color
    }

    BarText {
      text: stat.value
      color: stat.color
    }
  }

  // nf-md-battery_*: outline (0%), 10%..90%, full (100%)
  readonly property list<int> batteryGlyphs: [
    0xf008e, 0xf007a, 0xf007b, 0xf007c, 0xf007d, 0xf007e,
    0xf007f, 0xf0080, 0xf0081, 0xf0082, 0xf0079
  ]

  function batteryIcon(level, charging) {
    if (charging)
      return String.fromCodePoint(0xf0084) // nf-md-battery_charging
    const i = Math.max(0, Math.min(10, Math.round(level * 10)))
    return String.fromCodePoint(root.batteryGlyphs[i])
  }

  readonly property int compactWidth: 1600 // screens narrower than this use the compact bar
  readonly property int agendaTitleMaxWidth: 460 // px; longer titles in the agenda popup get "…"
  readonly property int popupGap: 4 // space between the bar and its popups
  readonly property string repeatGlyph: String.fromCodePoint(0xf0456) // nf-md-repeat
  readonly property int maxTitleLength: 40

  // "[qui ]09:15 - 10:00 Title 󰑖", or just "[qui ]09:15" when compact
  function eventLabel(e, compact) {
    if (compact)
      return Agenda.shortDayPrefix(e.date) + e.start
    const title = e.title.length > root.maxTitleLength
      ? e.title.slice(0, root.maxTitleLength - 1).trimEnd() + "…"
      : e.title
    return Agenda.shortDayPrefix(e.date) + e.start + " - " + e.end + " " + title
      + (e.recurring ? " " + root.repeatGlyph : "")
  }

  // Low battery notifications (via dunst/notify-send), once per threshold while discharging
  readonly property list<int> batteryAlertThresholds: [5, 10, 15] // ascending
  readonly property int batteryPercent: Math.round(UPower.displayDevice.percentage * 100)
  readonly property bool batteryDischarging: UPower.displayDevice.state === UPowerDeviceState.Discharging
  property int lastBatteryAlert: 101 // lowest threshold already notified in this discharge cycle

  onBatteryPercentChanged: checkBatteryAlert()
  onBatteryDischargingChanged: checkBatteryAlert()
  Component.onCompleted: checkBatteryAlert()

  function checkBatteryAlert() {
    if (!UPower.displayDevice.isLaptopBattery) return
    if (!root.batteryDischarging) {
      root.lastBatteryAlert = 101
      return
    }
    for (const threshold of root.batteryAlertThresholds) {
      if (root.batteryPercent <= threshold && threshold < root.lastBatteryAlert) {
        root.lastBatteryAlert = threshold
        const critical = threshold === root.batteryAlertThresholds[0]
        Quickshell.execDetached([
          "notify-send",
          "-u", critical ? "critical" : "normal",
          "-a", "Bateria",
          "-i", critical ? "battery-caution" : "battery-low",
          "-h", "string:x-dunst-stack-tag:battery-alert",
          `Bateria em ${root.batteryPercent}%`,
          critical ? "Conecte o carregador agora!" : "Considere conectar o carregador."
        ])
        return
      }
    }
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: barPerScreen
      required property var modelData
      screen: modelData

      // Narrow screens (e.g. the vertical monitor): shorter agenda label
      readonly property bool compact: width < root.compactWidth
      color: root.colBg

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30

      // Left - Workspaces
      RowLayout {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
          model: I3.workspaces

          Item {
            id: ws
            required property var modelData
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            visible: ws.modelData.monitor?.name === barPerScreen.screen.name

            BarText {
              anchors.centerIn: parent
              text: ws.modelData.name
              color: ws.modelData.focused ? root.colBlue : ws.modelData.urgent ? root.colYellow : root.colMuted
            }

            MouseArea {
              anchors.fill: parent
              onClicked: I3.dispatch(`workspace "${ws.modelData.name}"`)
            }
          }
        }
      }

      // Middle - Clock (click toggles the calendar popup)
      BarText {
        id: clockText
        anchors.centerIn: parent
        color: root.colBlue
        text: Qt.locale("pt_BR").toString(clock.date, "ddd dd MMM yyyy HH:mm").replace(/\./g, "")

        MouseArea {
          id: clockMouse
          anchors.fill: parent
          hoverEnabled: true
          onClicked: calendarPopup.visible = !calendarPopup.visible
        }
      }

      PopupWindow {
        id: calendarPopup
        // Anchored to the full bar height so the popup starts right below the bar
        anchor.window: barPerScreen
        anchor.rect.x: clockText.x
        anchor.rect.y: 0
        anchor.rect.width: clockText.width
        anchor.rect.height: barPerScreen.height + root.popupGap
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        implicitWidth: calendarContent.implicitWidth + 24
        implicitHeight: calendarContent.implicitHeight + 24
        color: root.colBg

        readonly property var ptBR: Qt.locale("pt_BR")
        property date selected: new Date()
        property int month: 0
        property int year: 0

        function sameDay(a, b) {
          return a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate()
        }

        function showMonth(y, m) {
          const first = new Date(y, m, 1)
          calendarPopup.year = first.getFullYear()
          calendarPopup.month = first.getMonth()
          Agenda.loadMonth(calendarPopup.year, calendarPopup.month)
        }

        function goToToday() {
          const now = new Date()
          calendarPopup.selected = new Date(now.getFullYear(), now.getMonth(), now.getDate())
          calendarPopup.showMonth(now.getFullYear(), now.getMonth())
        }

        onVisibleChanged: if (visible) goToToday()

        HoverHandler { id: calendarHover }

        // Close on click outside. X11 popups can't grab input, so watch raw
        // button presses globally (without intercepting them) while open.
        Process {
          command: ["stdbuf", "-oL", "xinput", "test-xi2", "--root"]
          running: calendarPopup.visible
          stdout: SplitParser {
            onRead: line => {
              if (line.includes("(RawButtonPress)") && !calendarHover.hovered && !clockMouse.containsMouse)
                calendarPopup.visible = false
            }
          }
        }

        Rectangle {
          anchors.fill: parent
          color: "transparent"
          border.color: root.colMuted
          border.width: 1
        }

        ColumnLayout {
          id: calendarContent
          anchors.centerIn: parent
          spacing: 8

          // Month navigation; clicking the title goes back to today
          RowLayout {
            Layout.fillWidth: true

            BarText {
              text: "" // nf-fa-chevron_left
              color: root.colFg
              MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                onClicked: calendarPopup.showMonth(calendarPopup.year, calendarPopup.month - 1)
              }
            }

            BarText {
              Layout.fillWidth: true
              horizontalAlignment: Text.AlignHCenter
              color: root.colBlue
              text: {
                const name = calendarPopup.ptBR.standaloneMonthName(calendarPopup.month)
                return name.charAt(0).toUpperCase() + name.slice(1) + " " + calendarPopup.year
              }
              MouseArea {
                anchors.fill: parent
                onClicked: calendarPopup.goToToday()
              }
            }

            BarText {
              text: "" // nf-fa-chevron_right
              color: root.colFg
              MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                onClicked: calendarPopup.showMonth(calendarPopup.year, calendarPopup.month + 1)
              }
            }
          }

          DayOfWeekRow {
            Layout.fillWidth: true
            locale: calendarPopup.ptBR
            delegate: BarText {
              required property string shortName
              horizontalAlignment: Text.AlignHCenter
              color: root.colMuted
              text: shortName.replace(/\./g, "").slice(0, 3)
            }
          }

          MonthGrid {
            id: monthGrid
            month: calendarPopup.month
            year: calendarPopup.year
            locale: calendarPopup.ptBR
            spacing: 2

            // Built from day/month/year roles: model.date is UTC midnight, which
            // lands on the previous day in negative UTC offsets
            delegate: Item {
              id: dayCell
              required property int day
              required property int month
              required property int year
              required property bool today
              readonly property date date: new Date(year, month, day)
              readonly property bool inMonth: month === monthGrid.month
              readonly property bool isSelected: calendarPopup.sameDay(date, calendarPopup.selected)
              readonly property bool hasEvents: Agenda.eventsOn(date).length > 0

              implicitWidth: 46
              implicitHeight: 30

              Rectangle {
                anchors.fill: parent
                radius: 4
                color: dayCell.today ? root.colBlue : "transparent"
                border.color: dayCell.isSelected && !dayCell.today ? root.colBlue : "transparent"
                border.width: 1
              }

              BarText {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -2
                text: dayCell.day
                font.bold: dayCell.today
                color: dayCell.today ? root.colBg : dayCell.inMonth ? root.colFg : root.colMuted
              }

              Rectangle {
                visible: dayCell.hasEvents
                width: 4
                height: 4
                radius: 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 3
                color: dayCell.today ? root.colBg : root.colCyan
              }

              MouseArea {
                anchors.fill: parent
                onClicked: {
                  calendarPopup.selected = dayCell.date
                  if (!dayCell.inMonth)
                    calendarPopup.showMonth(dayCell.year, dayCell.month)
                }
              }
            }
          }

          Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: root.colMuted
          }

          // Events of the selected day
          BarText {
            text: Agenda.dayLabel(calendarPopup.selected)
            color: root.colBlue
          }

          BarText {
            visible: Agenda.eventsOn(calendarPopup.selected).length === 0
            text: "Sem eventos"
            font.bold: false
            color: root.colMuted
          }

          Repeater {
            model: Agenda.eventsOn(calendarPopup.selected)

            BarText {
              required property var modelData
              Layout.maximumWidth: monthGrid.implicitWidth
              elide: Text.ElideRight
              font.bold: false
              color: root.colFg
              text: (modelData.allDay ? "Dia inteiro" : modelData.start + " - " + modelData.end)
                + "  " + modelData.title
                + (modelData.recurring ? " " + root.repeatGlyph : "")
            }
          }
        }
      }

      // Right Items
      RowLayout {
        id: rightItems
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 14

        // Next calendar event (khal); click toggles the agenda popup
        Item {
          id: agendaStat
          implicitWidth: agendaLabel.implicitWidth
          implicitHeight: agendaLabel.implicitHeight

          BarStat {
            id: agendaLabel
            icon: "" // nf-fa-calendar
            value: Agenda.next ? root.eventLabel(Agenda.next, barPerScreen.compact) : "Livre"
            color: root.colFg
          }

          MouseArea {
            id: agendaMouse
            anchors.fill: parent
            hoverEnabled: true // used by the click-outside check
            onClicked: agendaPopup.visible = !agendaPopup.visible
          }

          PopupWindow {
            id: agendaPopup
            // Anchored to the full bar height so the popup starts right below the bar
            anchor.window: barPerScreen
            anchor.rect.x: rightItems.x + agendaStat.x
            anchor.rect.y: 0
            anchor.rect.width: agendaStat.width
            anchor.rect.height: barPerScreen.height + root.popupGap
            anchor.edges: Edges.Bottom
            anchor.gravity: Edges.Bottom
            implicitWidth: agendaContent.implicitWidth + 24
            implicitHeight: agendaContent.implicitHeight + 24
            color: root.colBg

            Rectangle {
              anchors.fill: parent
              color: "transparent"
              border.color: root.colMuted
              border.width: 1
            }

            HoverHandler { id: agendaPopupHover }

            // Close on click outside (same approach as the calendar popup)
            Process {
              command: ["stdbuf", "-oL", "xinput", "test-xi2", "--root"]
              running: agendaPopup.visible
              stdout: SplitParser {
                onRead: line => {
                  if (line.includes("(RawButtonPress)") && !agendaPopupHover.hovered && !agendaMouse.containsMouse)
                    agendaPopup.visible = false
                }
              }
            }

            ColumnLayout {
              id: agendaContent
              anchors.centerIn: parent
              spacing: 4

              BarText {
                visible: Agenda.days.length === 0
                text: "Nenhum evento nos próximos " + Agenda.daysAhead + " dias"
                color: root.colMuted
              }

              Repeater {
                model: Agenda.days

                ColumnLayout {
                  id: dayGroup
                  required property var modelData
                  required property int index
                  spacing: 2

                  BarText {
                    Layout.topMargin: dayGroup.index > 0 ? 8 : 0
                    text: dayGroup.modelData.label
                    color: root.colBlue
                  }

                  Repeater {
                    model: dayGroup.modelData.events

                    // Long titles are elided; the repeat icon stays outside the cut
                    RowLayout {
                      id: eventRow
                      required property var modelData
                      spacing: 6

                      BarText {
                        font.bold: false
                        color: root.colFg
                        text: (eventRow.modelData.allDay ? "Dia inteiro" : eventRow.modelData.start + " - " + eventRow.modelData.end) + " "
                      }

                      BarText {
                        Layout.maximumWidth: root.agendaTitleMaxWidth
                        elide: Text.ElideRight
                        font.bold: false
                        color: root.colFg
                        text: eventRow.modelData.title
                      }

                      BarText {
                        visible: eventRow.modelData.recurring
                        font.bold: false
                        color: root.colFg
                        text: root.repeatGlyph
                      }
                    }
                  }
                }
              }
            }
          }
        }

        BarStat {
          icon: "" // nf-oct-cpu
          value: root.cpuUsage + "%"
          color: root.cpuUsage > 90 ? root.colRed : root.colYellow
        }

        BarStat {
          icon: "" // nf-fa-memory
          value: root.memUsage + "%"
          color: root.memUsage > 90 ? root.colRed : root.colCyan
        }

        BarStat {
          readonly property real level: UPower.displayDevice.percentage
          readonly property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging
          visible: UPower.displayDevice.isLaptopBattery
          icon: root.batteryIcon(level, charging)
          value: Math.round(level * 100) + "%"
          color: level < 0.05 && !charging ? root.colRed : root.colCyan
        }

        // Mic: click toggles mute
        BarIcon {
          readonly property bool micOn: !!Audio.source?.audio && !Audio.source.audio.muted
          icon: micOn ? "\uf130" : "\uf131" // nf-fa-microphone / microphone_slash
          sizeHint: "\uf131"
          color: micOn ? root.colYellow : root.colMuted

          MouseArea {
            id: micMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: Audio.toggleMicMute()
          }

          // Device name tooltip. A Controls ToolTip would be clipped by the 30px
          // bar (Popup.Window isn't available here), so use a popup window.
          Timer {
            id: micTooltipDelay
            interval: 500
            running: micMouse.containsMouse
          }

          PopupWindow {
            id: micTooltip
            visible: micMouse.containsMouse && !micTooltipDelay.running
            anchor.window: barPerScreen
            anchor.rect.x: rightItems.x + micMouse.parent.x
            anchor.rect.y: 0
            anchor.rect.width: micMouse.parent.width
            anchor.rect.height: barPerScreen.height + root.popupGap
            anchor.edges: Edges.Bottom
            anchor.gravity: Edges.Bottom
            implicitWidth: micTooltipText.implicitWidth + 16
            implicitHeight: micTooltipText.implicitHeight + 10
            color: root.colBg

            Rectangle {
              anchors.fill: parent
              color: "transparent"
              border.color: root.colMuted
              border.width: 1
            }

            BarText {
              id: micTooltipText
              anchors.centerIn: parent
              font.bold: false
              color: root.colFg
              text: {
                const source = Audio.source
                if (!source?.audio) return "Nenhum microfone"
                const name = source.nickname || source.description || source.name
                return name + (source.audio.muted ? " (mudo)" : " (ativo)")
              }
            }
          }
        }

        // Tray
        RowLayout {
          spacing: 6

          Repeater {
            model: SystemTray.items

            Item {
              id: trayEntry
              required property SystemTrayItem modelData
              Layout.preferredWidth: 15
              Layout.preferredHeight: 15

              QsWidgets.IconImage {
                source: trayEntry.modelData.icon
                implicitSize: 15
                anchors.centerIn: parent
              }

              MouseArea {
                id: trayMouse
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                hoverEnabled: true
                onClicked: mouse => {
                  const item = trayEntry.modelData
                  if (mouse.button === Qt.LeftButton) {
                    item.activate()
                  } else if (item.hasMenu) {
                    const p = trayMouse.mapToItem(null, mouse.x, mouse.y)
                    item.display(barPerScreen, p.x, p.y)
                  }
                }

                ToolTip {
                  visible: trayMouse.containsMouse && trayEntry.modelData.tooltipTitle !== ""
                  text: trayEntry.modelData.tooltipTitle
                  delay: 500
                  popupType: Popup.Item
                }
              }
            }
          }
        }
      }
    }
  }

  FileView { id: statFile; path: "/proc/stat" }
  FileView { id: meminfoFile; path: "/proc/meminfo" }

  function updateStats() {
    statFile.reload()
    meminfoFile.reload()

    // CPU: user nice system idle iowait irq softirq
    const cpu = statFile.text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/)
    if (cpu) {
      const p = cpu.slice(1).map(Number)
      const idle = p[3] + p[4]
      const total = p.reduce((a, b) => a + b, 0)
      if (root.lastCpuTotal > 0 && total > root.lastCpuTotal)
        root.cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)))
      root.lastCpuTotal = total
      root.lastCpuIdle = idle
    }

    // Memory: (MemTotal - MemAvailable) / MemTotal
    const mem = meminfoFile.text()
    const memTotal = Number(mem.match(/MemTotal:\s*(\d+)/)?.[1] ?? 0)
    const memAvailable = Number(mem.match(/MemAvailable:\s*(\d+)/)?.[1] ?? 0)
    if (memTotal > 0)
      root.memUsage = Math.round(100 * (memTotal - memAvailable) / memTotal)
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.updateStats()
  }
}
