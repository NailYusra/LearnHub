import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/screens/welcome_screen.dart'; // ganti your_project_name

void main() {
  testWidgets('WelcomeScreen UI Test', (WidgetTester tester) async {
    // Load the WelcomeScreen
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    // Cek apakah teks "Discover what you're looking for" muncul
    expect(find.text("Discover what\nyou're looking for"), findsOneWidget);

    // Cek apakah teks welcome subjudul muncul
    expect(
      find.text('Welcome to LearnHub – where learning gets easier, one step at a time!'),
      findsOneWidget,
    );

    // Cek apakah tombol "Login" ada
    expect(find.text('Login'), findsOneWidget);

    // Cek apakah tombol "Register" ada
    expect(find.text('Register'), findsOneWidget);

    // Cek apakah gambar welcome_logo muncul
    expect(
      find.byWidgetPredicate(
            (widget) =>
        widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/images/welcome_logo.png',
      ),
      findsOneWidget,
    );
  });
}
