import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:local/dal/remote/engine_client.dart';

/// Covers the edge-config key-value store client (used for the cron
/// scheduler's configurable target time in the Settings screen).
void main() {
  group('EngineClient — edge config', () {
    test('getConfig parses the backend map into Map<String, String>', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          expect(request.url.path, '/api/v1/config');
          return http.Response(jsonEncode({'cron_time': '06:30'}), 200);
        }),
      );

      final config = await client.getConfig();

      expect(config['cron_time'], '06:30');
    });

    test('getConfig returns an empty map (not a crash) when the engine is unreachable', () async {
      final client = EngineClient(
        client: MockClient((request) async => throw Exception('refused')),
      );

      final config = await client.getConfig();

      expect(config, isEmpty);
    });

    test('updateConfig sends the exact {configs: {...}} body shape', () async {
      Map<String, dynamic>? captured;
      final client = EngineClient(
        client: MockClient((request) async {
          captured = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response('{}', 200);
        }),
      );

      final ok = await client.updateConfig({'cron_time': '05:00'});

      expect(ok, isTrue);
      expect(captured!['configs'], {'cron_time': '05:00'});
    });

    test('updateConfig returns false (not a thrown exception) when the backend rejects a malformed value', () async {
      final client = EngineClient(
        client: MockClient((request) async {
          return http.Response(
            jsonEncode({'error': "Invalid cron_time: '25:00'", 'code': 'DOMAIN_VALIDATION_ERROR'}),
            400,
          );
        }),
      );

      final ok = await client.updateConfig({'cron_time': '25:00'});

      expect(ok, isFalse);
    });
  });
}
