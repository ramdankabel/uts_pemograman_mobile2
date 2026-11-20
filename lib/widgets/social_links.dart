import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SosmedLink {
  final String nama;
  final FaIconData ikon;
  final String url;

  const SosmedLink(this.nama, this.ikon, this.url);
}

/// Ganti URL di bawah dengan akun sosial media milikmu.
const List<SosmedLink> daftarSosmed = [
  SosmedLink('Facebook', FontAwesomeIcons.facebook,
      'https://facebook.com/muh.ramdannn'),
  SosmedLink('Instagram', FontAwesomeIcons.instagram,
      'https://instagram.com/muhramdannn'),
  SosmedLink('X', FontAwesomeIcons.xTwitter, 'https://x.com/ramdankabel'),
  SosmedLink('TikTok', FontAwesomeIcons.tiktok,
      'https://tiktok.com/@muhramdannn'),
  SosmedLink('YouTube', FontAwesomeIcons.youtube,
      'https://youtube.com/@ramdanqt'),
  SosmedLink('LinkedIn', FontAwesomeIcons.linkedin,
      'https://www.linkedin.com/in/muhammad-ramdan-55632b2b0?utm_source=share_via&utm_content=profile&utm_medium=member_android'),
  SosmedLink('GitHub', FontAwesomeIcons.github,
      'https://github.com/ramdankabel'),
];

/// Deretan ikon sosial media. [vertical] true = tersusun ke bawah.
class SocialLinks extends StatelessWidget {
  final bool vertical;

  const SocialLinks({super.key, this.vertical = false});

  @override
  Widget build(BuildContext context) {
    final tombol = daftarSosmed.map((s) => _SosmedButton(sosmed: s)).toList();
    return vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: tombol)
        : Row(mainAxisSize: MainAxisSize.min, children: tombol);
  }
}

class _SosmedButton extends StatelessWidget {
  final SosmedLink sosmed;

  const _SosmedButton({required this.sosmed});

  Future<void> _buka() async {
    final uri = Uri.parse(sosmed.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Tooltip(
        message: sosmed.nama,
        child: Material(
          color: Colors.white.withOpacity(0.18),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _buka,
            child: SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: FaIcon(sosmed.ikon, size: 15, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}