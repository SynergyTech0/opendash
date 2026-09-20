import QtQuick
import QtQuick.Layouts

// The USB library as a flat, scannable list backed by the C++ MediaModel.
// Tap a row to play it; tap the trash to delete it. The current track shows a
// live equalizer instead of its duration.
Item {
    id: view

    function fmt(s) {
        s = Math.max(0, Math.round(s));
        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12

        ViewHeading { text: "Media" }

        // usb header row
        RowLayout {
            width: parent.width
            Text {
                text: "USB 1  ·  " + Library.count + " tracks"
                color: Theme.dim
                font.family: Theme.display; font.pixelSize: 12; font.letterSpacing: 0.9
            }
            Item { Layout.fillWidth: true }
            Text {
                text: Library.usedMb.toFixed(1) + " MB / 32 GB"
                color: Theme.faint
                font.family: Theme.display; font.pixelSize: 12; font.letterSpacing: 0.9
            }
        }

        // empty state
        Text {
            visible: Library.count === 0
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Library empty — every track deleted. Bold move."
            color: Theme.dim
            font.family: Theme.body; font.pixelSize: 16
            topPadding: 30
        }

        ListView {
            id: list
            width: parent.width
            height: parent.height - y
            spacing: 6
            clip: true
            model: Library
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
                id: row
                required property int index
                required property string title
                required property string artist
                required property int duration
                required property int seed

                readonly property bool current: index === Playback.index
                width: ListView.view.width
                height: 64
                radius: Theme.rSm
                color: current ? Theme.panel : (rowHover.hovered ? Theme.panel : "transparent")
                border.color: current ? Theme.line : "transparent"
                border.width: 1

                HoverHandler { id: rowHover }
                TapHandler { onTapped: { Playback.playAt(row.index); Dash.view = "now"; } }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 14

                    AlbumArt {
                        seed: row.seed
                        Layout.preferredWidth: 44; Layout.preferredHeight: 44
                        radius: 10
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text {
                            text: row.title; color: Theme.ink
                            font.family: Theme.body; font.pixelSize: 15; font.weight: Font.DemiBold
                            Layout.fillWidth: true; elide: Text.ElideRight
                        }
                        Text {
                            text: row.artist; color: Theme.dim
                            font.family: Theme.body; font.pixelSize: 13
                            Layout.fillWidth: true; elide: Text.ElideRight
                        }
                    }

                    // live EQ (playing current track) or duration
                    Row {
                        id: eq
                        visible: row.current && Playback.playing
                        spacing: 2
                        Layout.preferredHeight: 16
                        Repeater {
                            model: 4
                            delegate: Item {
                                required property int index
                                width: 3; height: 16
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    width: 3; radius: 2; color: Theme.amber
                                    height: 6
                                    SequentialAnimation on height {
                                        running: eq.visible
                                        loops: Animation.Infinite
                                        PauseAnimation { duration: index * 90 }
                                        NumberAnimation { to: 16; duration: 450; easing.type: Easing.InOutSine }
                                        NumberAnimation { to: 5;  duration: 450; easing.type: Easing.InOutSine }
                                    }
                                }
                            }
                        }
                    }
                    Text {
                        visible: !(row.current && Playback.playing)
                        text: view.fmt(row.duration)
                        color: Theme.faint
                        font.family: Theme.display; font.pixelSize: 13
                    }

                    // delete
                    Rectangle {
                        Layout.preferredWidth: 38; Layout.preferredHeight: 38
                        radius: 10
                        color: trashTap.pressed ? Qt.rgba(1, 0.37, 0.34, 0.12) : "transparent"
                        DashIcon {
                            anchors.centerIn: parent
                            name: "trash"; size: 19
                            color: trashHover.hovered ? Theme.bad : Theme.faint
                        }
                        HoverHandler { id: trashHover }
                        TapHandler { id: trashTap; onTapped: Playback.deleteAt(row.index) }
                    }
                }
            }
        }
    }
}
