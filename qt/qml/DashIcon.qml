import QtQuick
import QtQuick.Shapes

// Renders one 24x24 SVG-path icon from the Icons singleton, tintable, scaled to
// `size`. Line icons are stroked; the play/pause/prev/next glyphs are filled.
Item {
    id: root

    property string name
    property real size: 24
    property color color: Theme.ink
    property real strokeWidth: 1.8

    readonly property bool _filled: Icons.filled.indexOf(name) !== -1

    implicitWidth: size
    implicitHeight: size

    Shape {
        anchors.fill: parent
        // Map the 24x24 viewBox onto the requested size.
        transform: Scale { xScale: root.size / 24; yScale: root.size / 24 }

        ShapePath {
            strokeColor: root._filled ? "transparent" : root.color
            fillColor: root._filled ? root.color : "transparent"
            strokeWidth: root.strokeWidth
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: Icons.d[root.name] ? Icons.d[root.name] : "" }
        }
    }
}
