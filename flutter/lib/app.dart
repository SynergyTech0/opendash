import 'dart:async';

import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';
import 'widgets.dart';
import 'screens/now_playing.dart';
import 'screens/media.dart';
import 'screens/climate.dart';
import 'screens/phone.dart';
import 'screens/settings.dart';

class OpenDashApp extends StatefulWidget {
  const OpenDashApp({super.key});
  @override
  State<OpenDashApp> createState() => _OpenDashAppState();
}

class _OpenDashAppState extends State<OpenDashApp> {
  final DashModel _model = DashModel();

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenDash',
      debugShowCheckedModeBanner: false,
      home: AnimatedBuilder(
        animation: _model,
        builder: (context, _) {
          return DashScope(
            model: _model,
            child: Scaffold(
              backgroundColor: _model.colors.screen,
              body: const _Shell(),
            ),
          );
        },
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell();

  @override
  Widget build(BuildContext context) {
    final m = DashScope.of(context);
    return Stack(
      children: [
        Column(
          children: [
            const _StatusBar(),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _content(m.screen)),
                  const _NavRail(),
                ],
              ),
            ),
          ],
        ),
        const _ToastHost(),
      ],
    );
  }

  Widget _content(DashScreen s) {
    switch (s) {
      case DashScreen.now:
        return const NowPlayingScreen();
      case DashScreen.media:
        return const MediaScreen();
      case DashScreen.climate:
        return const ClimateScreen();
      case DashScreen.phone:
        return const PhoneScreen();
      case DashScreen.settings:
        return const SettingsScreen();
    }
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    final m = DashScope.of(context);
    final c = m.colors;
    return Column(
      children: [
        Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          color: c.panel.withOpacity(0.6),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.clock, style: display(20, c.ink, weight: FontWeight.w600)),
                  Text(m.date, style: display(11, c.dim, spacing: 1)),
                ],
              ),
              const Spacer(),
              _chip(c, Icons.thermostat, '${m.outsideTempF}°', strong: true),
              const SizedBox(width: 16),
              _chip(c, Icons.bluetooth, 'BT', strong: false),
              const SizedBox(width: 16),
              _chip(c, Icons.network_cell, '4G', strong: true),
            ],
          ),
        ),
        Container(height: 1, color: c.line),
      ],
    );
  }

  Widget _chip(DashColors c, IconData icon, String label, {required bool strong}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: c.dim),
        const SizedBox(width: 6),
        Text(label,
            style: display(13, strong ? c.ink : c.dim,
                weight: strong ? FontWeight.w600 : FontWeight.w400)),
      ],
    );
  }
}

class _NavRail extends StatelessWidget {
  const _NavRail();

  @override
  Widget build(BuildContext context) {
    final m = DashScope.of(context);
    final c = m.colors;
    const icons = {
      DashScreen.now: Icons.music_note,
      DashScreen.media: Icons.format_list_bulleted,
      DashScreen.climate: Icons.thermostat,
      DashScreen.phone: Icons.phone,
      DashScreen.settings: Icons.settings,
    };
    return Row(
      children: [
        Container(width: 1, color: c.line),
        Container(
          width: 91,
          color: c.panel,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (final s in DashScreen.values) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () => m.goTo(s),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: m.screen == s ? c.amber : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icons[s], size: 26, color: m.screen == s ? c.onAmber : c.dim),
                          const SizedBox(height: 6),
                          Text(s.label.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: display(10, m.screen == s ? c.onAmber : c.dim, spacing: 0.6)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ToastHost extends StatefulWidget {
  const _ToastHost();
  @override
  State<_ToastHost> createState() => _ToastHostState();
}

class _ToastHostState extends State<_ToastHost> {
  int _lastSeq = 0;
  bool _visible = false;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final m = DashScope.of(context);
    if (m.toastSeq != _lastSeq) {
      _lastSeq = m.toastSeq;
      _visible = true;
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 2600), () {
        if (mounted) setState(() => _visible = false);
      });
    }
    final c = m.colors;
    final t = m.toast;
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: _visible && t != null ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: c.raise,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.line),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(t?.danger == true ? Icons.delete_outline : Icons.bolt,
                      size: 20, color: t?.danger == true ? c.bad : c.amber),
                  const SizedBox(width: 11),
                  Text.rich(richSpan(t?.message ?? '', body(14, c.ink))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
