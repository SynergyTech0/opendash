import QtQuick
import QtQuick.Layouts

// Bluetooth call surface (placeholder data). Shows the paired device and a
// short recents list.
Item {
    id: view

    readonly property var calls: [
        { name: "Boden Research", sub: "Mobile · 2m ago" },
        { name: "Shop",           sub: "Missed · 1h ago" },
        { name: "Voicemail",      sub: "1 new" }
    ]

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 14

        ViewHeading { text: "Phone" }

        // connected device
        Rectangle {
            width: parent.width
            height: 74
            radius: Theme.r
            color: Theme.panel; border.color: Theme.line; border.width: 1
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18; anchors.rightMargin: 18
                spacing: 14
                DashIcon { name: "phone"; size: 26; color: Theme.good }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: "Pixel 8 — Shane"; color: Theme.ink
                           font.family: Theme.body; font.pixelSize: 15; font.weight: Font.DemiBold }
                    Text { text: "Connected via Bluetooth · calls & media"; color: Theme.dim
                           font.family: Theme.body; font.pixelSize: 13 }
                }
                Rectangle {
                    radius: 20; color: Theme.panel2; border.color: Theme.line; border.width: 1
                    implicitWidth: hd.width + 24; implicitHeight: hd.height + 12
                    Text { id: hd; anchors.centerIn: parent; text: "HD VOICE"; color: Theme.dim
                           font.family: Theme.display; font.pixelSize: 11; font.letterSpacing: 0.8 }
                }
            }
        }

        // recents
        Rectangle {
            width: parent.width
            radius: Theme.r
            color: Theme.panel; border.color: Theme.line; border.width: 1
            height: callCol.implicitHeight + 20
            Column {
                id: callCol
                anchors.fill: parent
                anchors.margins: 10
                Repeater {
                    model: view.calls
                    delegate: Item {
                        required property var modelData
                        required property int index
                        width: parent.width
                        height: 60
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 4; anchors.rightMargin: 4
                            spacing: 14
                            Rectangle {
                                Layout.preferredWidth: 40; Layout.preferredHeight: 40
                                radius: 11; color: Theme.panel2
                                DashIcon { anchors.centerIn: parent; name: "phone"; size: 20; color: Theme.dim }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1
                                Text { text: modelData.name; color: Theme.ink
                                       Layout.fillWidth: true; horizontalAlignment: Text.AlignLeft
                                       font.family: Theme.body; font.pixelSize: 15; font.weight: Font.DemiBold }
                                Text { text: modelData.sub; color: Theme.dim
                                       Layout.fillWidth: true; horizontalAlignment: Text.AlignLeft
                                       font.family: Theme.body; font.pixelSize: 13 }
                            }
                            Text { text: "Call"; color: Theme.dim
                                   font.family: Theme.display; font.pixelSize: 14 }
                        }
                        Rectangle {
                            visible: index < view.calls.length - 1
                            anchors.bottom: parent.bottom
                            width: parent.width; height: 1; color: Theme.line
                        }
                    }
                }
            }
        }
    }
}
