import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = DashScope.of(context);
    final c = m.colors;
    final track = m.current;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ViewHeading('Now Playing'),
          const SizedBox(height: 16),
          if (track == null)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text('Nothing loaded. Add a thumb drive or pick a source.',
                  style: body(16, c.dim)),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    children: [
                      Positioned.fill(child: AlbumArt(seed: track.seed, corner: 18)),
                      Positioned(
                        left: 14,
                        bottom: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0x47000000),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(m.source.toUpperCase(),
                              style: display(11, Colors.white, spacing: 1.4)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 26),
                Expanded(child: _Info(m: m, track: track)),
              ],
            ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.m, required this.track});
  final DashModel m;
  final Track track;

  @override
  Widget build(BuildContext context) {
    final c = m.colors;
    final pct = track.duration > 0 ? (m.position / track.duration).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(track.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: body(30, c.ink, weight: FontWeight.bold)),
        Text(track.artist, style: body(16, c.dim)),
        const SizedBox(height: 18),

        // progress (tap / drag to seek)
        LayoutBuilder(builder: (context, cons) {
          void seek(double dx) => m.seekFraction(dx / cons.maxWidth);
          return GestureDetector(
            onTapDown: (d) => seek(d.localPosition.dx),
            onHorizontalDragUpdate: (d) => seek(d.localPosition.dx),
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: c.raise,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: pct.toDouble(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(colors: [c.amberDim, c.amber]),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(fmtTime(m.position), style: display(12, c.faint)),
            Text('-${fmtTime(track.duration - m.position)}', style: display(12, c.faint)),
          ],
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            _Round(icon: Icons.shuffle, size: 44, active: m.shuffle, onTap: m.toggleShuffle),
            const SizedBox(width: 10),
            _Round(icon: Icons.skip_previous, size: 52, onTap: m.prev),
            const SizedBox(width: 10),
            _Round(icon: m.playing ? Icons.pause : Icons.play_arrow, size: 66, primary: true, onTap: m.playPause),
            const SizedBox(width: 10),
            _Round(icon: Icons.skip_next, size: 52, onTap: m.next),
            const SizedBox(width: 10),
            _Round(icon: Icons.repeat, size: 44, active: m.repeat, onTap: m.toggleRepeat),
            const Spacer(),
            _DeleteButton(onTap: m.deleteCurrent),
          ],
        ),

        const SizedBox(height: 18),
        Row(
          children: [
            Icon(Icons.volume_up, size: 18, color: c.dim),
            const SizedBox(width: 6),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  activeTrackColor: c.amber,
                  inactiveTrackColor: c.raise,
                  thumbColor: c.amber,
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: m.volume.toDouble(),
                  min: 0,
                  max: 100,
                  onChanged: (v) => m.setVolume(v.round()),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _SourceToggle(m: m),
          ],
        ),
      ],
    );
  }
}

class _Round extends StatelessWidget {
  const _Round({required this.icon, required this.size, this.primary = false, this.active = false, required this.onTap});
  final IconData icon;
  final double size;
  final bool primary;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = DashScope.of(context).colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary ? c.amber : c.panel,
          border: primary ? null : Border.all(color: active ? c.amberDim : c.line),
        ),
        child: Icon(icon,
            size: size * 0.42,
            color: primary ? c.onAmber : (active ? c.amber : c.ink)),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = DashScope.of(context).colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0x14FF5F57),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFF4A2530)),
        ),
        child: Row(
          children: [
            Icon(Icons.delete_outline, size: 18, color: c.bad),
            const SizedBox(width: 9),
            Text('DELETE', style: display(12, c.bad, weight: FontWeight.w600, spacing: 1.2)),
          ],
        ),
      ),
    );
  }
}

class _SourceToggle extends StatelessWidget {
  const _SourceToggle({required this.m});
  final DashModel m;

  @override
  Widget build(BuildContext context) {
    final c = m.colors;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.panel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['USB', 'Bluetooth', 'Radio'].map((s) {
          final on = m.source == s;
          return GestureDetector(
            onTap: () => m.setSource(s),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: on ? c.raise : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(s.toUpperCase(), style: display(12, on ? c.ink : c.dim, spacing: 0.9)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
