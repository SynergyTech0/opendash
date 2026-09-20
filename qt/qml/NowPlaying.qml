import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

// Now Playing: album art, transport, scrubbable progress, volume, source, and
// the prominent Delete button. All state comes from the Playback controller.
Item {
    id: view

    function fmt(s) {
        s = Math.max(0, Math.round(s));
        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");
    }

    Flickable {
        anchors.fill: parent
        contentHeight: col.implicitHeight + 40
        clip: true

        Column {
            id: col
            x: 20; y: 20
            width: parent.width - 40
            spacing: 16

            ViewHeading { text: "Now Playing" }

            // ---- empty state ----
            Text {
                visible: !Playback.hasTrack
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "Nothing loaded. Add a thumb drive or pick a source."
                color: Theme.dim
                font.family: Theme.body
                font.pixelSize: 16
                topPadding: 40
            }

            RowLayout {
                visible: Playback.hasTrack
                width: parent.width
                spacing: 26

                AlbumArt {
                    seed: Playback.seed
                    Layout.preferredWidth: 220
                    Layout.preferredHeight: 220
                    radius: Theme.r

                    Rectangle {  // source tag
                        anchors.left: parent.left; anchors.bottom: parent.bottom
                        anchors.margins: 14
                        radius: 20
                        color: Qt.rgba(0, 0, 0, 0.28)
                        width: tagText.width + 18; height: tagText.height + 8
                        Text {
                            id: tagText
                            anchors.centerIn: parent
                            text: Playback.source.toUpperCase()
                            color: "#ffffff"
                            font.family: Theme.display; font.pixelSize: 11; font.letterSpacing: 1.4
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: Playback.title
                        color: Theme.ink
                        font.family: Theme.body; font.pixelSize: 30; font.weight: Font.Bold
                        Layout.fillWidth: true; elide: Text.ElideRight
                    }
                    Text {
                        text: Playback.artist
                        color: Theme.dim
                        font.family: Theme.body; font.pixelSize: 16
                        bottomPadding: 18
                    }

                    // progress bar (click / drag to seek)
                    Rectangle {
                        id: bar
                        Layout.fillWidth: true
                        Layout.preferredHeight: 6
                        radius: 3
                        color: Theme.raise
                        Rectangle {
                            height: parent.height; radius: 3
                            width: parent.width * (Playback.duration > 0
                                   ? Math.min(1, Playback.position / Playback.duration) : 0)
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0; color: Theme.amberDim }
                                GradientStop { position: 1; color: Theme.amber }
                            }
                        }
                        TapHandler { onTapped: (ev) => Playback.seekFraction(ev.position.x / bar.width) }
                        DragHandler {
                            target: null
                            onCentroidChanged: if (active) Playback.seekFraction(centroid.position.x / bar.width)
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 7
                        Text { text: view.fmt(Playback.position); color: Theme.faint
                               font.family: Theme.display; font.pixelSize: 12 }
                        Item { Layout.fillWidth: true }
                        Text { text: "-" + view.fmt(Playback.duration - Playback.position); color: Theme.faint
                               font.family: Theme.display; font.pixelSize: 12 }
                    }

                    // transport
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 16
                        spacing: 10

                        TransportButton { iconName: "shuffle"; diameter: 44; iconSize: 18
                            active: Playback.shuffle; onClicked: Playback.toggleShuffle() }
                        TransportButton { iconName: "prev"; onClicked: Playback.prev() }
                        TransportButton { iconName: Playback.playing ? "pause" : "play"
                            primary: true; diameter: 66; iconSize: 28; onClicked: Playback.playPause() }
                        TransportButton { iconName: "next"; onClicked: Playback.next() }
                        TransportButton { iconName: "repeat"; diameter: 44; iconSize: 18
                            active: Playback.repeat; onClicked: Playback.toggleRepeat() }

                        Item { Layout.fillWidth: true }

                        // Delete — the whole point of the project.
                        Rectangle {
                            Layout.preferredHeight: 52
                            Layout.preferredWidth: delRow.width + 36
                            radius: 26
                            color: delTap.pressed ? Qt.rgba(1, 0.37, 0.34, 0.16)
                                                  : Qt.rgba(1, 0.37, 0.34, 0.08)
                            border.color: "#4a2530"; border.width: 1
                            Row {
                                id: delRow
                                anchors.centerIn: parent
                                spacing: 9
                                DashIcon { name: "trash"; size: 18; color: Theme.bad
                                           anchors.verticalCenter: parent.verticalCenter }
                                Text { text: "DELETE"; color: Theme.bad
                                       font.family: Theme.display; font.pixelSize: 12; font.letterSpacing: 1.2; font.weight: Font.DemiBold
                                       anchors.verticalCenter: parent.verticalCenter }
                            }
                            TapHandler { id: delTap; onTapped: Playback.deleteCurrent() }
                        }
                    }

                    // volume + source
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 18
                        spacing: 16

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 180
                            spacing: 10
                            DashIcon { name: "vol"; size: 18; color: Theme.dim }
                            Slider {
                                id: vol
                                Layout.fillWidth: true
                                from: 0; to: 100; value: Playback.volume
                                onMoved: Playback.volume = value
                                background: Rectangle {
                                    x: vol.leftPadding; y: vol.topPadding + vol.availableHeight / 2 - height / 2
                                    width: vol.availableWidth; height: 6; radius: 3; color: Theme.raise
                                    Rectangle { width: vol.visualPosition * parent.width; height: parent.height
                                                radius: 3; color: Theme.amber }
                                }
                                handle: Rectangle {
                                    x: vol.leftPadding + vol.visualPosition * (vol.availableWidth - width)
                                    y: vol.topPadding + vol.availableHeight / 2 - height / 2
                                    width: 20; height: 20; radius: 10; color: Theme.amber
                                    border.color: Qt.rgba(1, 0.62, 0.17, 0.18); border.width: 4
                                }
                            }
                        }

                        Row {
                            spacing: 6
                            Rectangle {
                                radius: 22; color: Theme.panel; border.color: Theme.line; border.width: 1
                                width: srcRow.width + 8; height: srcRow.height + 8
                                Row {
                                    id: srcRow
                                    anchors.centerIn: parent
                                    spacing: 6
                                    Repeater {
                                        model: ["USB", "Bluetooth", "Radio"]
                                        delegate: Rectangle {
                                            required property string modelData
                                            readonly property bool isOn: Playback.source === modelData
                                            radius: 18
                                            color: isOn ? Theme.raise : "transparent"
                                            width: srcLabel.width + 28; height: srcLabel.height + 14
                                            Text {
                                                id: srcLabel
                                                anchors.centerIn: parent
                                                text: modelData.toUpperCase()
                                                color: isOn ? Theme.ink : Theme.dim
                                                font.family: Theme.display; font.pixelSize: 12; font.letterSpacing: 0.9
                                            }
                                            TapHandler { onTapped: Playback.source = modelData }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
