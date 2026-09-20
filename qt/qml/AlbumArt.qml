import QtQuick
import QtQuick.Shapes

// Generated album art: a radial gradient from the track's palette, matching the
// web preview's `radial-gradient(120% 120% at 20% 15%, inner, outer, #0a0e15)`.
// The outer Rectangle clips it to rounded corners.
Rectangle {
    id: root
    property int seed: 1

    radius: 12
    clip: true
    color: "#0a0e15"

    readonly property var _p: Theme.art(seed)

    Shape {
        anchors.fill: parent
        ShapePath {
            strokeColor: "transparent"
            fillGradient: RadialGradient {
                centerX: root.width * 0.2;  centerY: root.height * 0.15
                centerRadius: Math.max(root.width, root.height) * 1.1
                focalX: root.width * 0.2;   focalY: root.height * 0.15
                GradientStop { position: 0.0;  color: root._p[0] }
                GradientStop { position: 0.55; color: root._p[1] }
                GradientStop { position: 1.0;  color: "#0a0e15" }
            }
            startX: 0; startY: 0
            PathLine { x: root.width; y: 0 }
            PathLine { x: root.width; y: root.height }
            PathLine { x: 0;          y: root.height }
            PathLine { x: 0;          y: 0 }
        }
    }
}
