import QtQuick

// The "h2.view" heading: small uppercase label with a hairline running to the
// right edge. Used at the top of every view.
Row {
    property string text: ""
    width: parent ? parent.width : 0
    spacing: 10

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: parent.text.toUpperCase()
        color: Theme.dim
        font.family: Theme.display
        font.pixelSize: 14
        font.letterSpacing: 2.2
        font.weight: Font.DemiBold
    }
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - x
        height: 1
        color: Theme.line
    }
}
