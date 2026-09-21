import 'package:flutter/material.dart';
import 'package:farmer_app/app.dart';
import 'package:farmer_app/core/logs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  logInfo('Starting Oryza-Elo Farmer App...');
  runApp(const FarmerApp());
}
