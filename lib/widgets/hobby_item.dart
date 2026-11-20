import 'package:flutter/material.dart';

/// Kartu hobi dengan gambar latar. Bisa diklik untuk dipilih.
class HobbyItem extends StatelessWidget {
  final String nama;
  final String? gambar; // path aset, contoh: assets/images/hobi/musik.jpg
  final bool terpilih;
  final VoidCallback? onTap;

  const HobbyItem({
    super.key,
    required this.nama,
    this.gambar,
    this.terpilih = false,
    this.onTap,
  });

  IconData _ikon() {
    switch (nama.toLowerCase()) {
      case 'membaca':
        return Icons.menu_book;
      case 'fotografi':
        return Icons.camera_alt;
      case 'musik':
        return Icons.music_note;
      case 'gaming':
        return Icons.sports_esports;
      case 'traveling':
        return Icons.flight_takeoff;
      case 'olahraga':
        return Icons.sports_soccer;
      default:
        return Icons.favorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(14);

    // Warna cadangan bila gambar belum ada.
    final cadangan = Container(color: cs.primaryContainer);

    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Gambar latar
          if (gambar != null)
            Image.asset(
              gambar!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => cadangan,
            )
          else
            cadangan,

          // 2. Lapisan gelap agar teks terbaca
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: Colors.black.withOpacity(terpilih ? 0.30 : 0.55),
          ),

          // 3. Isi: ikon, nama, tanda centang
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(_ikon(), size: 20, color: cs.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    nama,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (terpilih)
                  Icon(Icons.check_circle, size: 20, color: cs.secondary),
              ],
            ),
          ),

          // 4. Garis tepi: kuning saat terpilih
          IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(
                  color: terpilih ? cs.secondary : cs.outlineVariant,
                  width: terpilih ? 2.5 : 1,
                ),
              ),
            ),
          ),

          // 5. Area klik dengan efek ripple
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
          ),
        ],
      ),
    );
  }
}