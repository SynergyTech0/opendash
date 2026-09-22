import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = DashScope.of(context);
    final c = m.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ViewHeading('Settings'),
          const SizedBox(height: 14),
          // preferences card
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.panel,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.line),
            ),
            child: Column(
              children: [
                _Row(
                  m: m, icon: Icons.dark_mode, primary: 'Night mode',
                  sub: 'Dark instrument look for driving after dark', divider: true,
                  trailing: _PillSwitch(m: m, on: !m.day, onTap: () => m.setDay(!m.day)),
                ),
                _Row(
                  m: m, icon: Icons.bolt, primary: 'Screen brightness',
                  sub: 'Auto-dims with the headlights', divider: true,
                  trailing: Text('${m.brightness}%', style: display(14, c.dim)),
                ),
                _Row(
                  m: m, icon: Icons.thermostat, primary: 'Temperature units',
                  sub: 'Cabin & outside readout', divider: false,
                  trailing: GestureDetector(
                    onTap: m.toggleUnits,
                    child: Text('°${m.units}', style: display(14, c.dim)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // dash background card (built-in presets)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: c.panel,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: c.panel2,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(Icons.wallpaper, size: 20, color: c.dim),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dash background', style: body(15, c.ink, weight: FontWeight.w600)),
                          Text('A backdrop behind the dash', style: body(13, c.dim)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Swatch(
                        selected: m.bgType == 'none',
                        onTap: m.clearBg,
                        color: c.panel2,
                        line: c.line,
                        amber: c.amber,
                        child: Icon(Icons.block, size: 18, color: c.faint),
                      ),
                      for (final key in kBgPresetKeys) ...[
                        const SizedBox(width: 10),
                        _Swatch(
                          selected: m.bgType == 'preset' && m.bgKey == key,
                          onTap: () => m.setBgPreset(key),
                          gradient: bgPresetGradient(key),
                          line: c.line,
                          amber: c.amber,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // about card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: c.panel,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.code, size: 20, color: c.amber),
                    const SizedBox(width: 10),
                    Text('ABOUT OPENDASH', style: display(13, c.ink, spacing: 1)),
                  ],
                ),
                const SizedBox(height: 12),
                Text.rich(
                  richSpan(
                    'A head-unit UI that treats the driver like a person, not a spec sheet. '
                    '<b>Two taps deep, max.</b> Big targets, high contrast, one accent, and every '
                    'destructive action is reversible — including, at long last, deleting a track.',
                    body(14, c.dim).copyWith(height: 1.5),
                  ),
                ),
                const SizedBox(height: 12),
                Text('v0.1 “Delete Button” · Flutter build',
                    style: body(13, c.faint)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.m, required this.icon, required this.primary,
    required this.sub, required this.divider, required this.trailing,
  });
  final DashModel m;
  final IconData icon;
  final String primary;
  final String sub;
  final bool divider;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final c = m.colors;
    return Column(
      children: [
        SizedBox(
          height: 62,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.panel2,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 20, color: c.dim),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(primary, style: body(15, c.ink, weight: FontWeight.w600)),
                    Text(sub, style: body(13, c.dim)),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
        if (divider) Container(height: 1, color: c.line),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.selected,
    required this.onTap,
    required this.line,
    required this.amber,
    this.gradient,
    this.color,
    this.child,
  });
  final bool selected;
  final VoidCallback onTap;
  final Color line;
  final Color amber;
  final Gradient? gradient;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? color : null,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? amber : line, width: 2),
        ),
        child: child,
      ),
    );
  }
}

class _PillSwitch extends StatelessWidget {
  const _PillSwitch({required this.m, required this.on, required this.onTap});
  final DashModel m;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = m.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 30,
        decoration: BoxDecoration(
          color: on ? c.amber : c.raise,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: on ? c.amber : c.line),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: on ? c.onAmber : c.ink,
            ),
          ),
        ),
      ),
    );
  }
}
