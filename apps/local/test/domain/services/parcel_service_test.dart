import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/services/parcel_service.dart';

/// Regression test for a real bug: the backend never generates a parcel id
/// (it stores exactly what it's given and rejects an empty one with 400
/// "Parcel ID cannot be empty"), but ParcelService.createParcel used to send
/// id: '' believing the backend would fill it in — every create silently
/// 400'd. It must always send a non-empty id.
void main() {
  test('createParcel always sends a non-empty id, never the old id: "" placeholder', () async {
    Map<String, dynamic>? captured;
    final client = EngineClient(
      client: MockClient((request) async {
        captured = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(request.body, 201, headers: {'content-type': 'application/json'});
      }),
    );
    final service = ParcelService(client: client);

    await service.createParcel(
      name: 'Talhão Teste',
      areaHectares: 1.0,
      latitude: 14.0,
      longitude: 100.0,
      riceEcosystem: 'Irrigated',
      riceVariety: 'RD43',
      sowingDate: DateTime.utc(2026, 4, 1),
    );

    expect(captured, isNotNull);
    expect(captured!['id'], isNotEmpty);
  });

  test('generated ids are unique across repeated calls with the same name', () async {
    final capturedIds = <String>[];
    final client = EngineClient(
      client: MockClient((request) async {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        capturedIds.add(body['id'] as String);
        return http.Response(request.body, 201, headers: {'content-type': 'application/json'});
      }),
    );
    final service = ParcelService(client: client);

    for (var i = 0; i < 5; i++) {
      await service.createParcel(
        name: 'Talhão Repetido',
        areaHectares: 1.0,
        latitude: 14.0,
        longitude: 100.0,
        riceEcosystem: 'Irrigated',
        riceVariety: 'RD43',
        sowingDate: DateTime.utc(2026, 4, 1),
      );
    }

    expect(capturedIds.toSet().length, 5);
  });
}
