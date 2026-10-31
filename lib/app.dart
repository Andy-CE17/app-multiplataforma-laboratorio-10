import 'package:flutter/material.dart';

import 'screens/image_list_view.dart';
import 'theme/app_theme.dart';

class LaboratoryApp extends StatelessWidget {
  const LaboratoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laboratorio 9',
      theme: AppTheme.lightTheme,
      home: const ImageListView(),
    );
  }
}
