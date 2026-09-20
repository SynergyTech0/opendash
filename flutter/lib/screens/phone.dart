import 'package:flutter/material.dart';

import '../theme.dart';
import '../models.dart';
import '../widgets.dart';

class PhoneScreen extends StatelessWidget {
  const PhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = DashScope.of(context).colors;
    const calls = [
      ('Boden Research', 'Mobile · 2m ago'),
      ('Shop', 'Missed · 1h ago'),
      ('Voicemail', '1 new'),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ViewHeading('Phone'),
          const SizedBox(height: 14),
          // connected device
          Container(
            height: 74,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: c.panel,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.line),
            ),
            child: Row(
              children: [
                Icon(Icons.phone, size: 26, color: c.good),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pixel 8 — Shane', style: body(15, c.ink, weight: FontWeight.w600)),
                      Text('Connected via Bluetooth · calls & media', style: body(13, c.dim)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.panel2,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: c.line),
                  ),
                  child: Text('HD VOICE', style: display(11, c.dim, spacing: 0.8)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // recents
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.panel,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.line),
            ),
            child: Column(
              children: [
                for (var i = 0; i < calls.length; i++) ...[
                  SizedBox(
                    height: 60,
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
                          child: Icon(Icons.phone, size: 20, color: c.dim),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(calls[i].$1, style: body(15, c.ink, weight: FontWeight.w600)),
                              Text(calls[i].$2, style: body(13, c.dim)),
                            ],
                          ),
                        ),
                        Text('Call', style: display(14, c.dim)),
                      ],
                    ),
                  ),
                  if (i < calls.length - 1) Container(height: 1, color: c.line),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
