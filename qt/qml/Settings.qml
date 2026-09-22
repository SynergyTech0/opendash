import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs

// Night/Day theme, brightness, units, a dash-background picker, and an About
// card. Night mode drives the whole HMI palette through Dash.day.
Item {
    id: view

    // Native file picker for "bring your own photo" backgrounds.
    FileDialog {
        id: bgDialog
        title: "Choose a dash background"
        nameFilters: ["Images (*.png *.jpg *.jpeg *.webp *.bmp)"]
        onAccepted: Dash.setBgImage(selectedFile)
    }

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

            // dash background card
            Rectangle {
                width: parent.width
                radius: Theme.r
                color: Theme.panel; border.color: Theme.line; border.width: 1
                height: bgcol.implicitHeight + 24

                Column {
                    id: bgcol
                    x: 12; y: 12
                    width: parent.width - 24
                    spacing: 12

                    RowLead { width: parent.width; icon: "image"; primary: "Dash background"
                              sub: "A backdrop behind the dash — a preset or your own photo" }

                    Flow {
                        width: parent.width
                        spacing: 10

                        // none
                        Rectangle {
                            width: 54; height: 38; radius: 10
                            color: Theme.panel2
                            border.width: 2
                            border.color: Dash.bgType === "none" ? Theme.amber : Theme.line
                            DashIcon { anchors.centerIn: parent; name: "ban"; size: 18; color: Theme.faint }
                            TapHandler { onTapped: Dash.clearBg() }
                        }

                        // built-in presets
                        Repeater {
                            model: [
                                { key: "aurora", c1: "#0b2b3a", c2: "#3a1d5c" },
                                { key: "ocean",  c1: "#0e3350", c2: "#071019" },
                                { key: "sunset", c1: "#3a1414", c2: "#b45309" },
                                { key: "ember",  c1: "#4a3008", c2: "#0a0e15" },
                                { key: "carbon", c1: "#0f1522", c2: "#0c111a" }
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                width: 54; height: 38; radius: 10
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: modelData.c1 }
                                    GradientStop { position: 1.0; color: modelData.c2 }
                                }
                                border.width: 2
                                border.color: (Dash.bgType === "preset" && Dash.bgKey === modelData.key)
                                              ? Theme.amber : Theme.line
                                TapHandler { onTapped: Dash.setBgPreset(modelData.key) }
                            }
                        }

                        // current photo (tap to clear)
                        Rectangle {
                            visible: Dash.bgType === "image"
                            width: 54; height: 38; radius: 10; clip: true
                            border.width: 2; border.color: Theme.amber
                            Image { anchors.fill: parent; source: Dash.bgImage; fillMode: Image.PreserveAspectCrop }
                            TapHandler { onTapped: Dash.clearBg() }
                        }

                        // upload
                        Rectangle {
                            width: 100; height: 38; radius: 10
                            color: Theme.panel2; border.color: Theme.line; border.width: 1
                            Row {
                                anchors.centerIn: parent; spacing: 8
                                DashIcon { name: "image"; size: 16; color: Theme.dim
                                           anchors.verticalCenter: parent.verticalCenter }
                                Text { text: Dash.bgType === "image" ? "CHANGE" : "UPLOAD"; color: Theme.dim
                                       font.family: Theme.display; font.pixelSize: 11; font.letterSpacing: 0.8
                                       anchors.verticalCenter: parent.verticalCenter }
                            }
                            TapHandler { onTapped: bgDialog.open() }
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
