import 'package:flutter_test/flutter_test.dart';
import 'package:profil_mahasiswa/main.dart';

void main() {
  testWidgets('Halaman profil menampilkan nama', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Muhammad Ramdan'), findsOneWidget);
    expect(find.text('Aktif'), findsOneWidget);
  });
}