import 'package:flutter/material.dart';
import 'package:local/app.dart';
import 'package:local/core/logs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  logInfo('Starting Oryza-Elo Farmer App...');
  runApp(const FarmerApp());
}
