import QtQuick
import QtQuick.Controls.Basic

// A round transport control. `primary` is the big amber play/pause button;
// `active` tints the icon amber (shuffle/repeat on). Everything else is a
// bordered panel circle.
AbstractButton {
    id: btn

    property string iconName
    property real diameter: 52
    property real iconSize: 22
    property bool primary: false
    property bool active: false

    implicitWidth: diameter
    implicitHeight: diameter

    background: Rectangle {
        radius: width / 2
        color: btn.primary
               ? Theme.amber
               : (btn.down ? Theme.panel2 : Theme.panel)
        border.width: btn.primary ? 0 : 1
        border.color: btn.active ? Theme.amberDim : Theme.line
        // Subtle press feedback like the web's :active scale.
        scale: btn.down ? 0.92 : 1.0
        Behavior on scale { NumberAnimation { duration: 60 } }
    }

    contentItem: Item {
        DashIcon {
            anchors.centerIn: parent
            name: btn.iconName
            size: btn.iconSize
            color: btn.primary ? Theme.onAmber
                               : (btn.active ? Theme.amber : Theme.ink)
        }
    }
}
