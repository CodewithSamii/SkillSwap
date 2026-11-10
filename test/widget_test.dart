import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap/main.dart';

void main() {
  testWidgets('SkillSwap smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillSwapApp());
    expect(find.text('SkillSwap'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
