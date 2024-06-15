import 'package:flutter_test/flutter_test.dart';

import 'package:todos/main.dart';

void main() {
  testWidgets('Test app', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());
  });
}
