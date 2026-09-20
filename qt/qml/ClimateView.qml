import QtQuick
import QtQuick.Layouts

// Dual-zone climate: temperature steppers, 6-speed fan, seat heaters, and the
// A/C · Auto · Recirc · defrost toggles. Bound to the ClimateController.
Item {
    id: view

    // one temperature zone
    component Zone: Rectangle {
        id: zone
        property string label
        property int temp
        property string zoneKey
        property string seatKey
        property int seatLevel

        Layout.fillWidth: true
        Layout.preferredHeight: 210
        radius: Theme.r
        color: Theme.panel
        border.color: Theme.line; border.width: 1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10
            width: parent.width - 36

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: zone.label.toUpperCase(); color: Theme.dim
                font.family: Theme.display; font.pixelSize: 11; font.letterSpacing: 1.6
            }
            Row {
                Layout.alignment: Qt.AlignHCenter
                Text {
                    text: zone.temp; color: Theme.ink
                    font.family: Theme.display; font.pixelSize: 52; font.weight: Font.Bold
                }
                Text {
                    text: "°F"; color: Theme.amber
                    font.family: Theme.display; font.pixelSize: 22
                    anchors.top: parent.top
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 14
                StepButton { glyph: "−"; onTapped: Climate.nudgeTemp(zone.zoneKey, -1) }
                StepButton { glyph: "+";      onTapped: Climate.nudgeTemp(zone.zoneKey, 1) }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 6
                Text { text: "SEAT"; color: Theme.faint
                       font.family: Theme.display; font.pixelSize: 10; font.letterSpacing: 1 }
                Repeater {
                    model: 3
                    delegate: Rectangle {
                        id: seatCell
                        required property int index
                        implicitWidth: 26; implicitHeight: 14; radius: 4
                        readonly property bool isOn: zone.seatLevel >= seatCell.index + 1
                        color: isOn ? Theme.amber : Theme.raise
                        border.color: isOn ? "transparent" : Theme.line; border.width: 1
                        TapHandler { onTapped: Climate.setSeat(zone.seatKey, seatCell.index + 1) }
                    }
                }
            }
        }
    }

    component StepButton: Rectangle {
        id: step
        signal tapped()
        property string glyph
        implicitWidth: 46; implicitHeight: 46; radius: 23
        color: Theme.panel2
        border.color: Theme.line; border.width: 1
        scale: tap.pressed ? 0.9 : 1.0
        Behavior on scale { NumberAnimation { duration: 60 } }
        Text { anchors.centerIn: parent; text: step.glyph; color: Theme.ink; font.pixelSize: 24 }
        TapHandler { id: tap; onTapped: step.tapped() }
    }

    component Toggle: Rectangle {
        id: tog
        property string icon
        property string label
        property bool isOn
        signal tapped()
        Layout.fillWidth: true
        Layout.preferredHeight: 52
        radius: 14
        color: isOn ? Theme.amber : Theme.panel
        border.color: isOn ? Theme.amber : Theme.line; border.width: 1
        Row {
            anchors.left: parent.left; anchors.leftMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            DashIcon { name: tog.icon; size: 20; color: tog.isOn ? Theme.onAmber : Theme.dim
                       anchors.verticalCenter: parent.verticalCenter }
            Text { text: tog.label; color: tog.isOn ? Theme.onAmber : Theme.dim
                   font.family: Theme.body; font.pixelSize: 14; font.weight: Font.DemiBold
                   anchors.verticalCenter: parent.verticalCenter }
        }
        TapHandler { onTapped: tog.tapped() }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: col.implicitHeight + 40
        clip: true

        ColumnLayout {
            id: col
            x: 20; y: 20
            width: parent.width - 40
            spacing: 16

            ViewHeading { text: "Climate" }

            RowLayout {
                Layout.fillWidth: true
                spacing: 16
                Zone { label: "Driver";    temp: Climate.driverTemp;    zoneKey: "driver"
                       seatKey: "seatLeft";  seatLevel: Climate.seatLeft }
                Zone { label: "Passenger"; temp: Climate.passengerTemp; zoneKey: "passenger"
                       seatKey: "seatRight"; seatLevel: Climate.seatRight }
            }

            // fan
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 54
                radius: Theme.r
                color: Theme.panel; border.color: Theme.line; border.width: 1
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18; anchors.rightMargin: 18
                    spacing: 14
                    Row {
                        spacing: 9
                        DashIcon { name: "fan"; size: 20; color: Theme.dim
                                   anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "FAN"; color: Theme.dim
                               font.family: Theme.display; font.pixelSize: 12; font.letterSpacing: 1
                               anchors.verticalCenter: parent.verticalCenter }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        Repeater {
                            model: 6
                            delegate: Rectangle {
                                required property int index
                                Layout.fillWidth: true
                                Layout.preferredHeight: 22
                                radius: 5
                                readonly property bool isOn: Climate.fan >= index + 1
                                color: isOn ? Theme.cyan : Theme.raise
                                TapHandler { onTapped: Climate.fan = index + 1 }
                            }
                        }
                    }
                }
            }

            // toggles
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                columnSpacing: 10
                rowSpacing: 10
                Toggle { icon: "snow";    label: "A/C";           isOn: Climate.ac;           onTapped: Climate.toggle("ac") }
                Toggle { icon: "auto";    label: "Auto";          isOn: Climate.autoMode;     onTapped: Climate.toggle("auto") }
                Toggle { icon: "recirc";  label: "Recirculate";   isOn: Climate.recirc;       onTapped: Climate.toggle("recirc") }
                Toggle { icon: "defrost"; label: "Front Defrost"; isOn: Climate.defrostFront; onTapped: Climate.toggle("defrostFront") }
                Toggle { icon: "defrost"; label: "Rear Defrost";  isOn: Climate.defrostRear;  onTapped: Climate.toggle("defrostRear") }
            }
        }
    }
}
