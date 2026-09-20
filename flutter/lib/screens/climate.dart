import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class ClimateScreen extends StatelessWidget {
  const ClimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = DashScope.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ViewHeading('Climate'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Zone(
                  m: m, label: 'Driver', temp: m.driverTemp, seat: m.seatLeft,
                  onMinus: () => m.nudgeTemp('driver', -1),
                  onPlus: () => m.nudgeTemp('driver', 1),
                  onSeat: (l) => m.setSeat('left', l),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _Zone(
                  m: m, label: 'Passenger', temp: m.passengerTemp, seat: m.seatRight,
                  onMinus: () => m.nudgeTemp('passenger', -1),
                  onPlus: () => m.nudgeTemp('passenger', 1),
                  onSeat: (l) => m.setSeat('right', l),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FanRow(m: m),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _Toggle(m: m, icon: Icons.ac_unit, label: 'A/C', on: m.ac, onTap: () => m.toggleClimate('ac'))),
              const SizedBox(width: 10),
              Expanded(child: _Toggle(m: m, icon: Icons.autorenew, label: 'Auto', on: m.auto, onTap: () => m.toggleClimate('auto'))),
              const SizedBox(width: 10),
              Expanded(child: _Toggle(m: m, icon: Icons.loop, label: 'Recirculate', on: m.recirc, onTap: () => m.toggleClimate('recirc'))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _Toggle(m: m, icon: Icons.waves, label: 'Front Defrost', on: m.defrostFront, onTap: () => m.toggleClimate('defrostFront'))),
              const SizedBox(width: 10),
              Expanded(child: _Toggle(m: m, icon: Icons.waves, label: 'Rear Defrost', on: m.defrostRear, onTap: () => m.toggleClimate('defrostRear'))),
              const SizedBox(width: 10),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class _Zone extends StatelessWidget {
  const _Zone({
    required this.m, required this.label, required this.temp, required this.seat,
    required this.onMinus, required this.onPlus, required this.onSeat,
  });
  final DashModel m;
  final String label;
  final int temp;
  final int seat;
  final VoidCallback onMinus, onPlus;
  final void Function(int) onSeat;

  @override
  Widget build(BuildContext context) {
    final c = m.colors;
    return Container(
      height: 210,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label.toUpperCase(), style: display(11, c.dim, spacing: 1.6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$temp', style: display(52, c.ink, weight: FontWeight.bold)),
              Text('°F', style: display(22, c.amber)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Stepper(m: m, glyph: '−', onTap: onMinus),
              const SizedBox(width: 14),
              _Stepper(m: m, glyph: '+', onTap: onPlus),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SEAT', style: display(10, c.faint, spacing: 1)),
              const SizedBox(width: 6),
              for (var l = 1; l <= 3; l++) ...[
                GestureDetector(
                  onTap: () => onSeat(l),
                  child: Container(
                    width: 26,
                    height: 14,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: seat >= l ? c.amber : c.raise,
                      borderRadius: BorderRadius.circular(4),
                      border: seat >= l ? null : Border.all(color: c.line),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.m, required this.glyph, required this.onTap});
  final DashModel m;
  final String glyph;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = m.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c.panel2,
          border: Border.all(color: c.line),
        ),
        child: Text(glyph, style: TextStyle(fontSize: 24, color: c.ink)),
      ),
    );
  }
}

class _FanRow extends StatelessWidget {
  const _FanRow({required this.m});
  final DashModel m;

  @override
  Widget build(BuildContext context) {
    final c = m.colors;
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: c.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Icon(Icons.air, size: 20, color: c.dim),
          const SizedBox(width: 9),
          Text('FAN', style: display(12, c.dim, spacing: 1)),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                for (var level = 1; level <= 6; level++) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => m.setFan(level),
                      child: Container(
                        height: 22,
                        margin: EdgeInsets.only(right: level < 6 ? 5 : 0),
                        decoration: BoxDecoration(
                          color: m.fan >= level ? c.cyan : c.raise,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.m, required this.icon, required this.label, required this.on, required this.onTap});
  final DashModel m;
  final IconData icon;
  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = m.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: on ? c.amber : c.panel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: on ? c.amber : c.line),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: on ? c.onAmber : c.dim),
            const SizedBox(width: 10),
            Flexible(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: body(14, on ? c.onAmber : c.dim, weight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
