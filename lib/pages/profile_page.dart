import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../widgets/hobby_item.dart';
import '../widgets/info_card.dart';
import '../widgets/skill_item.dart';
import '../widgets/social_links.dart';

class ProfilePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ProfilePage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Profile profile = profilContoh;
  final Set<String> _hobiDipilih = {};

  Color _warnaStatus(StatusMahasiswa s) {
    switch (s) {
      case StatusMahasiswa.aktif:
        return const Color(0xFF2E9E6B);
      case StatusMahasiswa.cuti:
        return const Color(0xFFE0A030);
      case StatusMahasiswa.lulus:
        return const Color(0xFF3B82C4);
    }
  }

  Widget _judul(String teks) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(teks, style: Theme.of(context).textTheme.titleLarge),
      );

  Widget _avatar() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: cs.secondary, width: 4),
        color: cs.surface,
      ),
      child: ClipOval(
        child: profile.fotoUrl.isEmpty
            ? Center(
                child: Text(profile.inisial,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: cs.primary)),
              )
            : Image.asset(
                profile.fotoUrl,
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.5),
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.person, size: 56, color: cs.primary),
              ),
      ),
    );
  }

  Widget _header() {
    final warna = _warnaStatus(profile.status);
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(profile.sampulPath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.45),
                  BlendMode.darken,
                ),
              ),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
          ),
          Positioned(
            top: 8,
            left: 16,
            child: SafeArea(
              child: SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 28,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      ' ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: SafeArea(
              child: IconButton(
                tooltip: widget.isDark ? 'Mode terang' : 'Mode gelap',
                onPressed: widget.onToggleTheme,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: Tween<double>(begin: 0.75, end: 1.0).animate(anim),
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: Icon(
                    widget.isDark ? Icons.light_mode : Icons.dark_mode,
                    key: ValueKey(widget.isDark),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _avatar(),
                const SizedBox(height: 12),
                Text(profile.nama,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('${profile.nim}  •  ${profile.jurusan}',
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: warna,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(profile.status.label,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            right: 12,
            bottom: 14,
            child: SocialLinks(
              vertical: MediaQuery.of(context).size.width < 600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _judul('Kontak & Data Diri'),
                  InfoCard(
                      icon: Icons.school,
                      label: 'Jurusan',
                      value: profile.jurusan),
                  InfoCard(
                      icon: Icons.badge, label: 'NIM', value: profile.nim),
                  InfoCard(
                      icon: Icons.email,
                      label: 'Email',
                      value: profile.email),
                  InfoCard(
                      icon: Icons.phone,
                      label: 'Telepon',
                      value: profile.telepon),
                  _judul('Hobi'),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profile.hobi.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.4,
                    ),
                    itemBuilder: (_, i) {
                      final h = profile.hobi[i];
                      return HobbyItem(
                        nama: h,
                        gambar: 'assets/images/hobi/${h.toLowerCase()}.jpg',
                        terpilih: _hobiDipilih.contains(h),
                        onTap: () => setState(() {
                          if (!_hobiDipilih.remove(h)) _hobiDipilih.add(h);
                        }),
                      );
                    },
                  ),
                  if (_hobiDipilih.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Dipilih: ${_hobiDipilih.join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  _judul('Skill'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profile.skill.length,
                    itemBuilder: (_, i) => SkillItem(skill: profile.skill[i]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Skill terkuat: ${profile.skillTerkuat.nama}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}