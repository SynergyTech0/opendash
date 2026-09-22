import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

import 'theme.dart';

class Track {
  final String title;
  final String artist;
  final int duration; // seconds
  final int seed;
  const Track(this.title, this.artist, this.duration, this.seed);
}

enum DashScreen {
  now('Now Playing'),
  media('Media'),
  climate('Climate'),
  phone('Phone'),
  settings('Settings');

  const DashScreen(this.label);
  final String label;
}

class ToastMsg {
  final String message;
  final bool danger;
  const ToastMsg(this.message, this.danger);
}

/// All OpenDash state and behaviour. The UI is a pure function of this model;
/// the delete button removes a real list element, the position advances on a
/// 1 Hz timer, and the clock ticks the same way. notifyListeners() drives
/// recomposition.
class DashModel extends ChangeNotifier {
  final List<Track> tracks = [
    const Track('Cold Start', 'Idle Hands', 222, 1),
    const Track('Amber Cluster', 'Nightdrive', 255, 2),
    const Track('Other Side of the Pillow', 'Kova', 178, 3),
    const Track('Thumb Drive Symphony', 'USB 1', 320, 4),
    const Track('Delete Button', 'The Engineers', 187, 5),
    const Track('Ham Radio Heartbreak', 'Clusterfunk', 231, 6),
    const Track('DIN Mount Blues', 'Scary Side', 242, 7),
  ];
  double get usedMb => tracks.length * 7.4;

  // playback
  int index = 1;
  int position = 64;
  bool playing = true;
  int volume = 62;
  String source = 'USB';
  bool shuffle = false;
  bool repeat = false;

  bool get hasTrack => tracks.isNotEmpty;
  Track? get current => hasTrack ? tracks[index] : null;

  // climate
  int driverTemp = 70;
  int passengerTemp = 72;
  int fan = 3;
  bool ac = true;
  bool auto = true;
  bool recirc = false;
  bool defrostFront = false;
  bool defrostRear = false;
  int seatLeft = 2;
  int seatRight = 0;

  // shell
  DashScreen screen = DashScreen.now;
  bool day = false;
  String units = 'F';
  final int brightness = 80;
  final int outsideTempF = 41;
  String clock = '';
  String date = '';

  // dash background. The Flutter build ships the built-in presets only ('none' |
  // 'preset'): the photo-upload and cross-launch persistence in the web/Qt/
  // Android builds need a platform file-picker / prefs package, which this build
  // deliberately avoids so it stays dependency-free and runs on flutter-elinux.
  String bgType = 'none';
  String? bgKey;

  DashColors get colors => day ? DashColors.day : DashColors.night;

  // toast: latest message + a counter so the UI knows when a new one arrives
  ToastMsg? toast;
  int toastSeq = 0;

  final _rng = Random();
  Timer? _timer;

  DashModel() {
    _updateClock();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
      _updateClock();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---- transport ----
  void playPause() {
    if (hasTrack) {
      playing = !playing;
      notifyListeners();
    }
  }

  void next() {
    if (!hasTrack) return;
    if (shuffle && tracks.length > 1) {
      var n = index;
      while (n == index) {
        n = _rng.nextInt(tracks.length);
      }
      index = n;
    } else {
      index = (index + 1) % tracks.length;
    }
    position = 0;
    playing = true;
    notifyListeners();
  }

  void prev() {
    if (!hasTrack) return;
    if (position > 4) {
      position = 0;
    } else {
      index = (index - 1 + tracks.length) % tracks.length;
      position = 0;
    }
    playing = true;
    notifyListeners();
  }

  void toggleShuffle() {
    shuffle = !shuffle;
    _toast(shuffle ? 'Shuffle on' : 'Shuffle off');
    notifyListeners();
  }

  void toggleRepeat() {
    repeat = !repeat;
    _toast(repeat ? 'Repeat on' : 'Repeat off');
    notifyListeners();
  }

  void setVolume(int v) {
    volume = v.clamp(0, 100);
    notifyListeners();
  }

  void setSource(String s) {
    source = s;
    _toast('Source: <b>$s</b>');
    notifyListeners();
  }

  void playAt(int i) {
    if (i < 0 || i >= tracks.length) return;
    index = i;
    position = 0;
    playing = true;
    screen = DashScreen.now;
    notifyListeners();
  }

  void seekFraction(double frac) {
    final t = current;
    if (t == null) return;
    position = (frac.clamp(0.0, 1.0) * t.duration).round();
    notifyListeners();
  }

  void deleteAt(int i) {
    if (i < 0 || i >= tracks.length) return;
    final gone = tracks.removeAt(i);
    if (index >= tracks.length) index = max(0, tracks.length - 1);
    if (tracks.isEmpty) playing = false;
    _toast('Removed <b>${gone.title}</b> — see? A delete button. '
        'Was that so hard?', danger: true);
    notifyListeners();
  }

  void deleteCurrent() => deleteAt(index);

  // ---- climate ----
  void nudgeTemp(String zone, int delta) {
    if (zone == 'driver') {
      driverTemp = (driverTemp + delta).clamp(60, 85);
    } else if (zone == 'passenger') {
      passengerTemp = (passengerTemp + delta).clamp(60, 85);
    }
    notifyListeners();
  }

  void setFan(int f) {
    fan = f.clamp(0, 6);
    notifyListeners();
  }

  void toggleClimate(String key) {
    switch (key) {
      case 'ac':
        ac = !ac;
      case 'auto':
        auto = !auto;
      case 'recirc':
        recirc = !recirc;
      case 'defrostFront':
        defrostFront = !defrostFront;
      case 'defrostRear':
        defrostRear = !defrostRear;
    }
    notifyListeners();
  }

  void setSeat(String side, int level) {
    if (side == 'left') {
      seatLeft = (seatLeft == level ? level - 1 : level).clamp(0, 3);
    } else if (side == 'right') {
      seatRight = (seatRight == level ? level - 1 : level).clamp(0, 3);
    }
    notifyListeners();
  }

  void goTo(DashScreen s) {
    screen = s;
    notifyListeners();
  }

  // ---- settings ----
  void setDay(bool value) {
    day = value;
    notifyListeners();
  }

  void toggleUnits() {
    units = units == 'F' ? 'C' : 'F';
    notifyListeners();
  }

  // ---- dash background ----
  void setBgPreset(String key) {
    bgType = 'preset';
    bgKey = key;
    notifyListeners();
  }

  void clearBg() {
    bgType = 'none';
    bgKey = null;
    notifyListeners();
  }

  void _toast(String message, {bool danger = false}) {
    toast = ToastMsg(message, danger);
    toastSeq++;
  }

  void _tick() {
    if (!playing || !hasTrack) return;
    final t = current!;
    position += 1;
    if (position >= t.duration) {
      position = 0;
      if (!repeat) index = (index + 1) % tracks.length;
    }
  }

  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];
  static const _days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  void _updateClock() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    clock = '${two(now.hour)}:${two(now.minute)}:${two(now.second)}';
    date = '${_days[now.weekday - 1]} ${_months[now.month - 1]} ${now.day}';
  }
}

/// Provides the [DashModel] to the widget tree.
class DashScope extends InheritedNotifier<DashModel> {
  const DashScope({super.key, required DashModel model, required super.child})
      : super(notifier: model);

  static DashModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DashScope>();
    assert(scope != null, 'DashScope not found in context');
    return scope!.notifier!;
  }
}
