import 'package:flutter_test/flutter_test.dart';

import 'package:mevos_fire/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MevosFireApp());
    expect(find.byType(MevosFireApp), findsOneWidget);
  });
}
