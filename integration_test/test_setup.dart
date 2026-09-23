import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> setupIntegrationEnv() async {
  dotenv.testLoad(
    fileInput: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key-1234567890
''',
  );
}
