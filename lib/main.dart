import 'package:flutter/material.dart';
import 'package:movrev/app/app.dart';
import 'package:movrev/app/injection.dart' as di;

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initInjection();
  runApp(const MovRevApp());
}

