import 'package:flutter/widgets.dart';

/// OpenDash design tokens, straight from the web preview's CSS variables.
/// Two instances — [night] and [day] — flip the whole instrument look.
@immutable
class DashColors {
  final Color bg, screen, panel, panel2, raise, line;
  final Color ink, dim, faint;
  final Color amber, amberDim, cyan, good, bad, onAmber;

  const DashColors({
    required this.bg,
    required this.screen,
    required this.panel,
    required this.panel2,
    required this.raise,
    required this.line,
    required this.ink,
    required this.dim,
    required this.faint,
    required this.amber,
    required this.amberDim,
    required this.cyan,
    required this.good,
    required this.bad,
    required this.onAmber,
  });

  static const night = DashColors(
    bg: Color(0xFF070A0F),
    screen: Color(0xFF0B0F16),
    panel: Color(0xFF121824),
    panel2: Color(0xFF19212F),
    raise: Color(0xFF212B3B),
    line: Color(0xFF242F40),
    ink: Color(0xFFEEF3F9),
    dim: Color(0xFF8896A8),
    faint: Color(0xFF5C6879),
    amber: Color(0xFFFF9E2C),
    amberDim: Color(0xFFB96F1C),
    cyan: Color(0xFF3AD0D8),
    good: Color(0xFF54E07F),
    bad: Color(0xFFFF5F57),
    onAmber: Color(0xFF0B0F16),
  );

  static const day = DashColors(
    bg: Color(0xFFC9D1DC),
    screen: Color(0xFFEEF1F6),
    panel: Color(0xFFFFFFFF),
    panel2: Color(0xFFF3F6FB),
    raise: Color(0xFFE7ECF3),
    line: Color(0xFFD3DAE4),
    ink: Color(0xFF161D29),
    dim: Color(0xFF5A6879),
    faint: Color(0xFF8B98A8),
    amber: Color(0xFFE07A12),
    amberDim: Color(0xFFC9690C),
    cyan: Color(0xFF0E9AA2),
    good: Color(0xFF54E07F),
    bad: Color(0xFFFF5F57),
    onAmber: Color(0xFFFFFFFF),
  );
}

/// Built-in dash-background preset keys, shared by every OpenDash stack.
const List<String> kBgPresetKeys = ['aurora', 'ocean', 'sunset', 'ember', 'carbon'];

/// The gradient for a background preset key, or null for "none"/unknown.
Gradient? bgPresetGradient(String? key) {
  const begin = Alignment.topLeft, end = Alignment.bottomRight;
  switch (key) {
    case 'aurora':
      return const LinearGradient(begin: begin, end: end,
          colors: [Color(0xFF0B2B3A), Color(0xFF132A4D), Color(0xFF3A1D5C)]);
    case 'ocean':
      return const LinearGradient(begin: begin, end: end,
          colors: [Color(0xFF0E3350), Color(0xFF071019)]);
    case 'sunset':
      return const LinearGradient(begin: begin, end: end,
          colors: [Color(0xFF3A1414), Color(0xFF7A2410), Color(0xFFB45309)]);
    case 'ember':
      return const LinearGradient(begin: begin, end: end,
          colors: [Color(0xFF4A3008), Color(0xFF0A0E15)]);
    case 'carbon':
      return const LinearGradient(begin: begin, end: end,
          colors: [Color(0xFF0F1522), Color(0xFF0C111A)]);
    default:
      return null;
  }
}

/// Font families. The web preview uses Chakra Petch (instrument / numeric) and
/// Barlow (body). Add the .ttf files + pubspec entries and swap these strings
/// to "ChakraPetch" / "Barlow"; until then they fall back to the platform sans.
const String kDisplayFont = ''; // '' => platform default
const String kBodyFont = '';

TextStyle display(double size, Color color,
        {FontWeight weight = FontWeight.w500, double spacing = 0}) =>
    TextStyle(
      fontFamily: kDisplayFont.isEmpty ? null : kDisplayFont,
      fontSize: size,
      color: color,
      fontWeight: weight,
      letterSpacing: spacing,
    );

TextStyle body(double size, Color color, {FontWeight weight = FontWeight.w400}) =>
    TextStyle(
      fontFamily: kBodyFont.isEmpty ? null : kBodyFont,
      fontSize: size,
      color: color,
      fontWeight: weight,
    );
