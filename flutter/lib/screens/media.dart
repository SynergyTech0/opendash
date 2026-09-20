import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = DashScope.of(context);
    final c = m.colors;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ViewHeading('Media'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('USB 1  ·  ${m.tracks.length} tracks',
                  style: display(12, c.dim, spacing: 0.9)),
              Text('${m.usedMb.toStringAsFixed(1)} MB / 32 GB',
                  style: display(12, c.faint, spacing: 0.9)),
            ],
          ),
          const SizedBox(height: 12),
          if (m.tracks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text('Library empty — every track deleted. Bold move.',
                  style: body(16, c.dim)),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: m.tracks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) => _TrackRow(
                  m: m,
                  track: m.tracks[i],
                  index: i,
                  current: i == m.index,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({required this.m, required this.track, required this.index, required this.current});
  final DashModel m;
  final Track track;
  final int index;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final c = m.colors;
    return GestureDetector(
      onTap: () => m.playAt(index),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: current ? c.panel : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: current ? Border.all(color: c.line) : null,
        ),
        child: Row(
          children: [
            SizedBox(width: 44, height: 44, child: AlbumArt(seed: track.seed, corner: 10)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: body(15, c.ink, weight: FontWeight.w600)),
                  Text(track.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: body(13, c.dim)),
                ],
              ),
            ),
            if (current && m.playing)
              _Equalizer(color: c.amber)
            else
              Text(fmtTime(track.duration), style: display(13, c.faint)),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => m.deleteAt(index),
              child: SizedBox(
                width: 38,
                height: 38,
                child: Icon(Icons.delete_outline, size: 19, color: c.faint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Equalizer extends StatefulWidget {
  const _Equalizer({required this.color});
  final Color color;
  @override
  State<_Equalizer> createState() => _EqualizerState();
}

class _EqualizerState extends State<_Equalizer> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(4, (i) {
              final phase = (_c.value + i * 0.22) % 1.0;
              final t = (phase * 2 <= 1) ? phase * 2 : 2 - phase * 2; // triangle 0..1
              final h = 5 + t * 11;
              return Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Container(
                  width: 3,
                  height: h,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
