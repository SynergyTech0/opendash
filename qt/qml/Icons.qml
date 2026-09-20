pragma Singleton
import QtQuick

// The icon set from the web preview, as raw SVG path data on a 24x24 viewBox.
// DashIcon renders these with Qt Quick Shapes so they can be tinted and either
// stroked (line icons) or filled (play/pause/prev/next). `filled` lists the
// names that should be painted solid instead of stroked.
QtObject {
    readonly property var filled: ["play", "pause", "prev", "next"]

    readonly property var d: ({
        "music":    "M9 18V5l11-2v13 M6 18 m-3 0 a3 3 0 1 0 6 0 a3 3 0 1 0 -6 0 M17 16 m-3 0 a3 3 0 1 0 6 0 a3 3 0 1 0 -6 0",
        "list":     "M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01",
        "climate":  "M12 3v18M3 12h18M5.6 5.6l12.8 12.8M18.4 5.6 5.6 18.4",
        "phone":    "M5 4h4l2 5-3 2a12 12 0 0 0 5 5l2-3 5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2Z",
        "settings": "M12 9 a3 3 0 1 0 0 6 a3 3 0 1 0 0 -6 M19.4 15a1.6 1.6 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.6 1.6 0 0 0-2.7 1.1V21a2 2 0 0 1-4 0v-.2A1.6 1.6 0 0 0 7 19.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1A1.6 1.6 0 0 0 5 12.6H4.8a2 2 0 0 1 0-4H5a1.6 1.6 0 0 0 1.1-2.7l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1A1.6 1.6 0 0 0 12 3.4V3a2 2 0 0 1 4 0v.2a1.6 1.6 0 0 0 2.7 1.1l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.6 1.6 0 0 0-.3 1.8Z",
        "play":     "M7 5.5v13a1 1 0 0 0 1.5.87l11-6.5a1 1 0 0 0 0-1.74l-11-6.5A1 1 0 0 0 7 5.5Z",
        "pause":    "M6 5h4v14H6zM14 5h4v14h-4z",
        "prev":     "M6 5h2v14H6zM20 5.5v13a1 1 0 0 1-1.5.87l-9-6.5a1 1 0 0 1 0-1.74l9-6.5A1 1 0 0 1 20 5.5Z",
        "next":     "M16 5h2v14h-2zM4 5.5v13a1 1 0 0 0 1.5.87l9-6.5a1 1 0 0 0 0-1.74l-9-6.5A1 1 0 0 0 4 5.5Z",
        "shuffle":  "M16 3h5v5M4 20 21 3M21 16v5h-5M15 15l6 6M4 4l5 5",
        "repeat":   "M17 2l4 4-4 4M3 11V9a4 4 0 0 1 4-4h14M7 22l-4-4 4-4M21 13v2a4 4 0 0 1-4 4H3",
        "trash":    "M3 6h18M8 6V4a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2m2 0v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6M10 11v6M14 11v6",
        "vol":      "M11 5 6 9H2v6h4l5 4V5ZM16 9a3 3 0 0 1 0 6M19 6a7 7 0 0 1 0 12",
        "fan":      "M12 10a2 2 0 1 0 0 4a2 2 0 1 0 0-4 M12 10c0-4 1-7 2-7s2 2 0 5M14 12c4 0 7 1 7 2s-2 2-5 0M12 14c0 4-1 7-2 7s-2-2 0-5M10 12c-4 0-7-1-7-2s2-2 5 0",
        "snow":     "M12 2v20M4 6l16 12M20 6 4 18M2 12h20",
        "auto":     "M6 16 9 8l3 8M6.8 14h4.4M15 8v8M15 8h3a2 2 0 0 1 0 4h-3",
        "recirc":   "M3 12a9 9 0 0 1 15-6.7L21 8M21 12a9 9 0 0 1-15 6.7L3 16M21 4v4h-4M3 20v-4h4",
        "defrost":  "M4 13a8 8 0 0 1 16 0M6 20c.5-2 1-3 1-3M11 20c.5-2 1-3 1-3M16 20c.5-2 1-3 1-3",
        "moon":     "M21 12.8A9 9 0 1 1 11.2 3 7 7 0 0 0 21 12.8Z",
        "bolt":     "M13 2 4 14h7l-1 8 9-12h-7l1-8Z",
        "code":     "m9 18-6-6 6-6M15 6l6 6-6 6",
        "bt":       "M6 12a6 6 0 0 1 12 0M9 12a3 3 0 0 1 6 0",
        "signal":   "M3 8.5 12 4l9 4.5M6 11l6-3 6 3M9 13.5l3-1.5 3 1.5",
        "temp":     "M14 14.76V5a2 2 0 1 0-4 0v9.76a4 4 0 1 0 4 0Z"
    })
}
