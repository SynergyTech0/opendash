import QtQuick

// Bottom-centre toast. Call show(message, danger); it fades in, holds ~2.6s,
// and fades out — the same feedback the web preview gives on delete/source.
Item {
    id: root
    anchors.fill: parent

    function show(message, danger) {
        label.text = message;
        glyph.name = danger ? "trash" : "bolt";
        glyph.color = danger ? Theme.bad : Theme.amber;
        bubble.opacity = 1;
        bubble.y = bubble._rest;
        hideTimer.restart();
    }

    Rectangle {
        id: bubble
        readonly property real _rest: root.height - height - 30
        x: (root.width - width) / 2
        y: _rest + 20
        width: row.width + 36
        height: row.height + 24
        radius: 14
        color: Theme.raise
        border.color: Theme.line
        border.width: 1
        opacity: 0
        visible: opacity > 0

        Behavior on opacity { NumberAnimation { duration: 250 } }
        Behavior on y { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 11

            DashIcon {
                id: glyph
                anchors.verticalCenter: parent.verticalCenter
                name: "bolt"
                size: 20
            }
            Text {
                id: label
                anchors.verticalCenter: parent.verticalCenter
                textFormat: Text.StyledText   // the messages use <b>…</b>
                color: Theme.ink
                font.family: Theme.body
                font.pixelSize: 14
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 2600
        onTriggered: { bubble.opacity = 0; bubble.y = bubble._rest + 20; }
    }
}
