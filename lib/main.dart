import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/profile_page.dart';

void main() => runApp(const MyApp());

/// Palet warna konsisten.
class AppColors {
  static const primary = Color(0xFF1F3A5F); // biru tinta
  static const secondary = Color(0xFFE0A030); // kuning ambar
  static const bgLight = Color(0xFFF4F6F9);
  static const bgDark = Color(0xFF101722);
  static const surfaceDark = Color(0xFF182233);
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: dark ? const Color(0xFF8DB4E8) : AppColors.primary,
    onPrimary: dark ? AppColors.bgDark : Colors.white,
    primaryContainer: dark ? const Color(0xFF24456E) : const Color(0xFF3F6397),
    secondary: AppColors.secondary,
    onSecondary: Colors.black,
    error: const Color(0xFFB3261E),
    onError: Colors.white,
    surface: dark ? AppColors.surfaceDark : Colors.white,
    onSurface: dark ? const Color(0xFFE6ECF5) : const Color(0xFF14202F),
    outlineVariant: dark ? const Color(0xFF2B3A52) : const Color(0xFFDDE3EC),
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? AppColors.bgDark : AppColors.bgLight,
  );
  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  bool isDark = false;

  final GlobalKey _boundaryKey = GlobalKey();
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  );

  ui.Image? _oldImage; // tangkapan layar tema lama
  Offset _center = Offset.zero; // titik awal lingkaran

  @override
  void dispose() {
    _ctrl.dispose();
    _oldImage?.dispose();
    super.dispose();
  }

  Future<void> _toggleTheme() async {
    if (_ctrl.isAnimating) return;

    final boundary = _boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;

    // Cadangan: bila tangkapan layar gagal, ganti tema biasa.
    if (boundary == null) {
      setState(() => isDark = !isDark);
      return;
    }

    try {
      final ratio = View.of(context).devicePixelRatio;
      final image = await boundary.toImage(pixelRatio: ratio);
      _center = Offset(boundary.size.width - 32, 32); // posisi tombol tema
      setState(() {
        _oldImage = image;
        isDark = !isDark;
      });
      await _ctrl.forward(from: 0);
    } catch (_) {
      setState(() => isDark = !isDark);
    } finally {
      final old = _oldImage;
      if (mounted) setState(() => _oldImage = null);
      WidgetsBinding.instance.addPostFrameCallback((_) => old?.dispose());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muhammad Ramdan',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: Duration.zero, // transisi diatur sendiri
      builder: (context, child) {
        return Stack(
          children: [
            RepaintBoundary(
              key: _boundaryKey,
              child: child ?? const SizedBox.shrink(),
            ),
            if (_oldImage != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) => CustomPaint(
                      painter: _RevealPainter(
                        image: _oldImage!,
                        center: _center,
                        t: _ctrl.value,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      home: ProfilePage(
        isDark: isDark,
        onToggleTheme: () {
          _toggleTheme();
        },
      ),
    );
  }
}

/// Menggambar tema lama dengan "lubang" lingkaran yang terus membesar,
/// sehingga tema baru tampak menyebar dari tombol.
class _RevealPainter extends CustomPainter {
  final ui.Image image;
  final Offset center;
  final double t;

  _RevealPainter({
    required this.image,
    required this.center,
    required this.t,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Jarak ke sudut terjauh = radius akhir.
    final dx = math.max(center.dx, size.width - center.dx);
    final dy = math.max(center.dy, size.height - center.dy);
    final maxR = math.sqrt(dx * dx + dy * dy);
    final r = maxR * Curves.easeInOutCubic.transform(t);

    final layar = Path()..addRect(Offset.zero & size);
    final lubang = Path()
      ..addOval(Rect.fromCircle(center: center, radius: r));
    final jejak = Path.combine(PathOperation.difference, layar, lubang);

    canvas.save();
    canvas.clipPath(jejak);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Offset.zero & size,
      Paint(),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RevealPainter old) =>
      old.t != t || old.image != image || old.center != center;
}