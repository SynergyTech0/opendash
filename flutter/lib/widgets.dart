import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';

// Generated album-art palettes (inner, outer), keyed by track seed — the same
// set every OpenDash stack ships.
const _palettes = <List<Color>>[
  [Color(0xFFFF9E2C), Color(0xFF7A3BFF)],
  [Color(0xFF3AD0D8), Color(0xFF155E75)],
  [Color(0xFFFF5F7E), Color(0xFF7A1F3D)],
  [Color(0xFF54E07F), Color(0xFF1C5E3A)],
  [Color(0xFFFFCF5C), Color(0xFFB45309)],
  [Color(0xFF6AA1FF), Color(0xFF1E2F66)],
  [Color(0xFFFF7A3C), Color(0xFF7A2410)],
  [Color(0xFFC58BFF), Color(0xFF3B1470)],
];

/// A radial-gradient "album cover" derived from the track seed.
class AlbumArt extends StatelessWidget {
  const AlbumArt({super.key, required this.seed, this.corner = 12});
  final int seed;
  final double corner;

  @override
  Widget build(BuildContext context) {
    final p = _palettes[seed % _palettes.length];
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(corner),
        gradient: RadialGradient(
          // center at ~20%,15% of the box, matching the web preview
          center: const Alignment(-0.6, -0.7),
          radius: 1.2,
          colors: [p[0], p[1], const Color(0xFF0A0E15)],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}

/// The "h2.view" section heading: uppercase label + a hairline to the edge.
class ViewHeading extends StatelessWidget {
  const ViewHeading(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = DashScope.of(context).colors;
    return Row(
      children: [
        Text(text.toUpperCase(),
            style: display(14, c.dim, weight: FontWeight.w600, spacing: 2.2)),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: c.line)),
      ],
    );
  }
}

String fmtTime(int seconds) {
  final s = seconds < 0 ? 0 : seconds;
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}

/// Renders the tiny "<b>…</b>" markup used in toast/about copy as bold spans.
TextSpan richSpan(String html, TextStyle base) {
  final spans = <TextSpan>[];
  var i = 0;
  var bold = false;
  final buf = StringBuffer();
  void flush() {
    if (buf.isEmpty) return;
    spans.add(TextSpan(
      text: buf.toString(),
      style: bold ? base.copyWith(fontWeight: FontWeight.bold) : base,
    ));
    buf.clear();
  }

  while (i < html.length) {
    if (html.startsWith('<b>', i)) {
      flush();
      bold = true;
      i += 3;
    } else if (html.startsWith('</b>', i)) {
      flush();
      bold = false;
      i += 4;
    } else {
      buf.write(html[i]);
      i += 1;
    }
  }
  flush();
  return TextSpan(children: spans, style: base);
}
