import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindsafe/core/providers/core_providers.dart';
import 'package:mindsafe/core/services/storage_service.dart';
import 'package:mindsafe/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MindSafeApp builds with storage override', (tester) async {
    final storage = StorageService.inMemory();
    await storage.initialize();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
        ],
        child: const MindSafeApp(),
      ),
    );

    // Allow splash bootstrap timers to start.
    await tester.pump();
    expect(find.byType(MindSafeApp), findsOneWidget);
  });
}
