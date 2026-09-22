import QtQuick
import QtQuick.Window

// The head unit. On an embedded target this is the whole screen; on the desktop
// it opens at a typical double-DIN 1040x560. Status bar on top, content + nav
// rail below, toast floating over everything.
Window {
    id: win
    visible: true
    width: 1040
    height: 600
    minimumWidth: 640
    minimumHeight: 420
    title: "OpenDash"
    color: Theme.bg

    // The five destinations and their nav-rail icons.
    readonly property var nav: [
        { id: "now",     label: "Now Playing", icon: "music" },
        { id: "media",   label: "Media",       icon: "list" },
        { id: "climate", label: "Climate",     icon: "climate" },
        { id: "phone",   label: "Phone",       icon: "phone" },
        { id: "set",     label: "Settings",    icon: "settings" }
    ]

    Rectangle {
        id: screen
        anchors.fill: parent
        anchors.margins: 10
        radius: 20
        color: Theme.screen
        border.color: Theme.line
        border.width: 1
        clip: true

        // ---- user-chosen dash background (sits behind the whole UI) ----
        Item {
            anchors.fill: parent
            visible: Dash.bgType !== "none"

            Rectangle { anchors.fill: parent; visible: Dash.bgType === "preset" && Dash.bgKey === "aurora"
                gradient: Gradient { GradientStop { position: 0.0; color: "#0b2b3a" } GradientStop { position: 0.45; color: "#132a4d" } GradientStop { position: 1.0; color: "#3a1d5c" } } }
            Rectangle { anchors.fill: parent; visible: Dash.bgType === "preset" && Dash.bgKey === "ocean"
                gradient: Gradient { GradientStop { position: 0.0; color: "#0e3350" } GradientStop { position: 1.0; color: "#071019" } } }
            Rectangle { anchors.fill: parent; visible: Dash.bgType === "preset" && Dash.bgKey === "sunset"
                gradient: Gradient { GradientStop { position: 0.0; color: "#3a1414" } GradientStop { position: 0.55; color: "#7a2410" } GradientStop { position: 1.0; color: "#b45309" } } }
            Rectangle { anchors.fill: parent; visible: Dash.bgType === "preset" && Dash.bgKey === "ember"
                gradient: Gradient { GradientStop { position: 0.0; color: "#4a3008" } GradientStop { position: 1.0; color: "#0a0e15" } } }
            Rectangle { anchors.fill: parent; visible: Dash.bgType === "preset" && Dash.bgKey === "carbon"
                gradient: Gradient { GradientStop { position: 0.0; color: "#0f1522" } GradientStop { position: 1.0; color: "#0c111a" } } }

            Image { anchors.fill: parent; visible: Dash.bgType === "image"
                source: Dash.bgImage; fillMode: Image.PreserveAspectCrop; asynchronous: true; cache: false }

            // legibility scrim — lighter in day mode, darker at night
            Rectangle {
                anchors.fill: parent
                color: Theme.day ? Qt.rgba(0.93, 0.945, 0.965, 0.42)
                                 : Qt.rgba(0.027, 0.039, 0.059, 0.5)
            }
        }

        Column {
            anchors.fill: parent

            // ---- status bar ----
            Rectangle {
                width: parent.width
                height: 58
                color: Qt.rgba(Theme.panel.r, Theme.panel.g, Theme.panel.b, 0.6)

                Rectangle {  // bottom hairline
                    anchors.bottom: parent.bottom
                    width: parent.width; height: 1; color: Theme.line
                }

                Item {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    anchors.rightMargin: 18

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 1
                        Text {
                            text: Dash.clock
                            color: Theme.ink
                            font.family: Theme.display
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                        }
                        Text {
                            text: Dash.date
                            color: Theme.dim
                            font.family: Theme.display
                            font.pixelSize: 11
                            font.letterSpacing: 1
                        }
                    }

                    Row {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 16

                        Row {
                            spacing: 6
                            anchors.verticalCenter: parent.verticalCenter
                            DashIcon { name: "temp"; size: 16; color: Theme.dim
                                       anchors.verticalCenter: parent.verticalCenter }
                            Text { text: Dash.outsideTempF + "°"; color: Theme.ink
                                   font.family: Theme.display; font.pixelSize: 14; font.weight: Font.DemiBold
                                   anchors.verticalCenter: parent.verticalCenter }
                        }
                        Row {
                            spacing: 6
                            anchors.verticalCenter: parent.verticalCenter
                            DashIcon { name: "bt"; size: 16; color: Theme.dim
                                       anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "BT"; color: Theme.dim; font.family: Theme.display; font.pixelSize: 13
                                   anchors.verticalCenter: parent.verticalCenter }
                        }
                        Row {
                            spacing: 6
                            anchors.verticalCenter: parent.verticalCenter
                            DashIcon { name: "signal"; size: 16; color: Theme.dim
                                       anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "4G"; color: Theme.ink; font.family: Theme.display; font.pixelSize: 13; font.weight: Font.DemiBold
                                   anchors.verticalCenter: parent.verticalCenter }
                        }
                    }
                }
            }

            // ---- body: content + nav rail ----
            Row {
                width: parent.width
                height: parent.height - 58

                // content
                Loader {
                    id: content
                    width: parent.width - nav.width
                    height: parent.height
                    source: {
                        switch (Dash.view) {
                        case "now":     return "NowPlaying.qml";
                        case "media":   return "Media.qml";
                        case "climate": return "ClimateView.qml";
                        case "phone":   return "Phone.qml";
                        default:        return "Settings.qml";
                        }
                    }
                }

                // nav rail
                Rectangle {
                    id: nav
                    width: 92
                    height: parent.height
                    color: Theme.panel

                    Rectangle { width: 1; height: parent.height; color: Theme.line }  // left hairline

                    Column {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 6

                        Repeater {
                            model: win.nav
                            delegate: Rectangle {
                                required property var modelData
                                width: parent.width
                                height: 66
                                radius: 14
                                readonly property bool isOn: Dash.view === modelData.id
                                color: isOn ? Theme.amber
                                            : (hover.hovered ? Theme.panel2 : "transparent")

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 6
                                    DashIcon {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        name: modelData.icon
                                        size: 26
                                        color: parent.parent.isOn ? Theme.onAmber : Theme.dim
                                    }
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: modelData.label.toUpperCase()
                                        color: parent.parent.isOn ? Theme.onAmber : Theme.dim
                                        font.family: Theme.display
                                        font.pixelSize: 10
                                        font.letterSpacing: 0.6
                                    }
                                }

                                HoverHandler { id: hover }
                                TapHandler { onTapped: Dash.view = modelData.id }
                            }
                        }
                    }
                }
            }
        }
    }

    // ---- toast, wired to the backend ----
    Toast { id: toast }

    Connections {
        target: Playback
        function onToast(message, danger) { toast.show(message, danger); }
    }
}
