import 'dart:math';

import 'package:local/dal/remote/engine_client.dart';
import 'package:local/domain/models/parcel.dart';

/// Pure domain service for farm parcel operations.
class ParcelService {
  final EngineClient _client;
  final Random _random;

  ParcelService({EngineClient? client, Random? random})
      : _client = client ?? EngineClient(),
        _random = random ?? Random();

  Future<List<FarmParcel>> fetchParcels() => _client.getParcels();

  Future<FarmParcel?> createParcel({
    required String name,
    required double areaHectares,
    required double latitude,
    required double longitude,
    required String riceEcosystem,
    required String riceVariety,
    required DateTime sowingDate,
  }) {
    final parcel = FarmParcel(
      // The backend never generates an id: it stores exactly the id it is
      // given and rejects an empty one (400 "Parcel ID cannot be empty").
      // Client must supply a unique business key up front.
      id: _generateParcelId(name),
      name: name,
      areaHectares: areaHectares,
      latitude: latitude,
      longitude: longitude,
      riceEcosystem: riceEcosystem,
      riceVariety: riceVariety,
      sowingDate: sowingDate,
    );
    return _client.createParcel(parcel);
  }

  String _generateParcelId(String name) {
    final slug = name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final base = slug.isEmpty ? 'talhao' : slug;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '$base-$suffix';
  }

  Future<FarmParcel?> updateParcel(FarmParcel parcel) => _client.updateParcel(parcel);

  Future<bool> deleteParcel(String id) => _client.deleteParcel(id);
}
