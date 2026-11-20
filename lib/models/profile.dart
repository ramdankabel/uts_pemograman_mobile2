/// Status kemahasiswaan.
enum StatusMahasiswa { aktif, cuti, lulus }

extension StatusMahasiswaX on StatusMahasiswa {
  String get label {
    switch (this) {
      case StatusMahasiswa.aktif:
        return 'Aktif';
      case StatusMahasiswa.cuti:
        return 'Cuti';
      case StatusMahasiswa.lulus:
        return 'Lulus';
    }
  }
}

/// Satu keahlian beserta tingkat penguasaan (0.0 - 1.0).
class Skill {
  final String nama;
  final double level;

  const Skill(this.nama, this.level);
}

class Profile {
  final String nama;
  final String nim;
  final String jurusan;
  final String email;
  final String telepon;
  final String fotoUrl;
  final String sampulPath;
  final List<String> hobi;
  final List<Skill> skill;
  final StatusMahasiswa status;

  const Profile({
    required this.nama,
    required this.nim,
    required this.jurusan,
    required this.email,
    required this.telepon,
    required this.fotoUrl,
    required this.sampulPath,
    required this.hobi,
    required this.skill,
    required this.status,
  });

  /// Inisial nama, dipakai bila foto kosong.
  String get inisial {
    final bagian = nama.trim().split(RegExp(r'\s+'));
    return bagian.take(2).map((e) => e[0].toUpperCase()).join();
  }

  /// Fungsi untuk menampilkan data ringkas.
  String ringkasan() =>
      '$nama ($nim) - $jurusan | Status: ${status.label} | '
      '${hobi.length} hobi, ${skill.length} skill';

  /// Fungsi untuk memanipulasi data: skill dengan level tertinggi.
  Skill get skillTerkuat => skill.reduce((a, b) => a.level >= b.level ? a : b);
}

/// Data contoh - ganti dengan data dirimu sendiri.
const profilContoh = Profile(
  nama: 'Muhammad Ramdan',
  nim: '24552011065',
  jurusan: 'Teknik Informatika',
  email: 'mohramdhan013@gmail.com',
  telepon: '+62 821-1842-7261',
  fotoUrl: 'assets/images/foto.jpg',
  sampulPath: 'assets/images/sampul.jpg',
  status: StatusMahasiswa.aktif,
  hobi: ['Membaca', 'Fotografi', 'Musik', 'Gaming', 'Traveling', 'Olahraga'],
  skill: [
    Skill('Flutter', 0.8),
    Skill('Dart', 0.75),
    Skill('UI/UX Design', 0.65),
    Skill('Firebase', 0.55),
    Skill('Git', 0.7),
  ],
);
