pragma Singleton
import QtQuick

// Design tokens, straight from the web preview's :root variables. Every colour
// switches on Dash.day so the whole HMI flips between the amber-on-charcoal
// night instrument look and the daylight theme from one place.
QtObject {
    id: t

    readonly property bool day: Dash.day

    // surfaces
    readonly property color bg:     day ? "#c9d1dc" : "#070a0f"
    readonly property color screen: day ? "#eef1f6" : "#0b0f16"
    readonly property color panel:  day ? "#ffffff" : "#121824"
    readonly property color panel2: day ? "#f3f6fb" : "#19212f"
    readonly property color raise:  day ? "#e7ecf3" : "#212b3b"
    readonly property color line:   day ? "#d3dae4" : "#242f40"

    // ink
    readonly property color ink:    day ? "#161d29" : "#eef3f9"
    readonly property color dim:     day ? "#5a6879" : "#8896a8"
    readonly property color faint:   day ? "#8b98a8" : "#5c6879"

    // accents / semantic
    readonly property color amber:    day ? "#e07a12" : "#ff9e2c"
    readonly property color amberDim:  day ? "#c9690c" : "#b96f1c"
    readonly property color cyan:      day ? "#0e9aa2" : "#3ad0d8"
    readonly property color good:      "#54e07f"
    readonly property color bad:       "#ff5f57"
    // Text colour to sit on top of an amber fill (dark on night amber, white on day).
    readonly property color onAmber:   day ? "#ffffff" : "#0b0f16"

    // radii
    readonly property int r:   18
    readonly property int rSm: 12

    // fonts — bundled if present, else sensible platform fallbacks
    readonly property string display: "Chakra Petch"   // instrument / numeric
    readonly property string body:    "Barlow"         // labels / body

    // Generated album-art palettes (inner, outer), keyed by track seed. Same
    // set as the web preview so art matches across every OpenDash stack.
    readonly property var palettes: [
        ["#ff9e2c", "#7a3bff"], ["#3ad0d8", "#155e75"], ["#ff5f7e", "#7a1f3d"],
        ["#54e07f", "#1c5e3a"], ["#ffcf5c", "#b45309"], ["#6aa1ff", "#1e2f66"],
        ["#ff7a3c", "#7a2410"], ["#c58bff", "#3b1470"]
    ]
    function art(seed) { return palettes[Math.abs(seed) % palettes.length]; }
}
