import QtQuick
import QtQuick.Layouts

// Night/Day theme, brightness, units, and an About card. Night mode drives the
// whole HMI palette through Dash.day.
Item {
    id: view

    // A pill switch. Emits toggled(); the caller owns the state.
    component Sw: Rectangle {
        property bool isOn
        signal toggled()
        width: 52; height: 30; radius: 15
        color: isOn ? Theme.amber : Theme.raise
        border.color: isOn ? Theme.amber : Theme.line; border.width: 1
        Rectangle {
            width: 22; height: 22; radius: 11
            y: 3; x: parent.isOn ? 25 : 3
            color: parent.isOn ? Theme.onAmber : Theme.ink
            Behavior on x { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        }
        TapHandler { onTapped: parent.toggled() }
    }

    // The leading icon + primary/sub text shared by every settings row.
    component RowLead: RowLayout {
        id: lead
        property string icon
        property string primary
        property string sub
        spacing: 14
        Rectangle {
            Layout.preferredWidth: 40; Layout.preferredHeight: 40
            radius: 11; color: Theme.panel2
            DashIcon { anchors.centerIn: parent; name: lead.icon; size: 20; color: Theme.dim }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1
            Text { text: lead.primary; color: Theme.ink
                   font.family: Theme.body; font.pixelSize: 15; font.weight: Font.DemiBold }
            Text { text: lead.sub; color: Theme.dim; font.family: Theme.body; font.pixelSize: 13
                   Layout.fillWidth: true; elide: Text.ElideRight }
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: col.implicitHeight + 40
        clip: true

        Column {
            id: col
            x: 20; y: 20
            width: parent.width - 40
            spacing: 14

            ViewHeading { text: "Settings" }

            // preferences card
            Rectangle {
                width: parent.width
                radius: Theme.r
                color: Theme.panel; border.color: Theme.line; border.width: 1
                height: rows.implicitHeight + 16
                Column {
                    id: rows
                    anchors.fill: parent
                    anchors.margins: 8

                    // night mode
                    Item {
                        width: parent.width; height: 62
                        RowLayout {
                            anchors.fill: parent
                            RowLead { Layout.fillWidth: true; icon: "moon"; primary: "Night mode"
                                      sub: "Dark instrument look for driving after dark" }
                            Sw { isOn: !Dash.day; onToggled: Dash.day = !Dash.day }
                        }
                        Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.line }
                    }

                    // brightness
                    Item {
                        width: parent.width; height: 62
                        RowLayout {
                            anchors.fill: parent
                            RowLead { Layout.fillWidth: true; icon: "bolt"; primary: "Screen brightness"
                                      sub: "Auto-dims with the headlights" }
                            Text { text: Dash.brightness + "%"; color: Theme.dim
                                   font.family: Theme.display; font.pixelSize: 14 }
                        }
                        Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.line }
                    }

                    // units
                    Item {
                        width: parent.width; height: 62
                        RowLayout {
                            anchors.fill: parent
                            RowLead { Layout.fillWidth: true; icon: "climate"; primary: "Temperature units"
                                      sub: "Cabin & outside readout" }
                            Text {
                                text: "°" + Dash.units; color: Theme.dim
                                font.family: Theme.display; font.pixelSize: 14
                                TapHandler { onTapped: Dash.toggleUnits() }
                            }
                        }
                    }
                }
            }

            // about card
            Rectangle {
                width: parent.width
                radius: Theme.r
                color: Theme.panel; border.color: Theme.line; border.width: 1
                height: about.implicitHeight + 36
                Column {
                    id: about
                    x: 18; y: 18
                    width: parent.width - 36
                    spacing: 12
                    Row {
                        spacing: 10
                        DashIcon { name: "code"; size: 20; color: Theme.amber
                                   anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "ABOUT OPENDASH"; color: Theme.ink
                               font.family: Theme.display; font.pixelSize: 13; font.letterSpacing: 1
                               anchors.verticalCenter: parent.verticalCenter }
                    }
                    Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        textFormat: Text.StyledText
                        color: Theme.dim
                        font.family: Theme.body; font.pixelSize: 14; lineHeight: 1.5
                        text: "A head-unit UI that treats the driver like a person, not a spec " +
                              "sheet. <b>Two taps deep, max.</b> Big targets, high contrast, one " +
                              "accent, and every destructive action is reversible — including, " +
                              "at long last, deleting a track."
                    }
                    Text {
                        text: "v0.1 “Delete Button” · Qt/QML build"
                        color: Theme.faint
                        font.family: Theme.body; font.pixelSize: 13
                    }
                }
            }
        }
    }
}
