
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final assets = [
    "assets/student/_0028.png",
    "assets/student/_0017.png",
    "assets/student/_0040.png",
    "assets/student/_0005.png",
    "assets/icons3d/file-text-dynamic-color.png",
    "assets/blueprint/01_rpi5_blueprint.jpg",
    "assets/blueprint/02_rpi5_exploded.jpg",
    "assets/blueprint/03_rpizero2w_blueprint.jpg",
    "assets/blueprint/04_rpizero2w_exploded.jpg",
    "assets/blueprint/05_esp32_lora_blueprint.jpg",
    "assets/blueprint/06_esp32_lora_exploded.jpg",
    "assets/blueprint/07_water_sensor_blueprint.jpg",
    "assets/blueprint/08_water_sensor_exploded.jpg",
    "assets/blueprint/09_soil_probe_blueprint.jpg",
    "assets/blueprint/10_soil_probe_exploded.jpg",
    "assets/blueprint/11_solar_station_blueprint.jpg",
    "assets/blueprint/12_solar_station_exploded.jpg",
    "assets/icons3d/clock-dynamic-color.png",
    "assets/icons3d/target-dynamic-color.png",
    "assets/icons3d/sun-dynamic-color.png",
    "assets/icons3d/wifi-dynamic-color.png",
    "assets/plants/Jungle_Plant_1.png",
    "assets/plants/Jungle_Plant_2.png",
    "assets/plants/Jungle_Plant_3.png",
    "assets/plants/Jungle_Plant_4.png",
  ];

  for (final path in assets) {
    test("Asset loads: \$path", () async {
      final byteData = await rootBundle.load(path);
      expect(byteData.lengthInBytes, greaterThan(0));
    });
  }
}
