// lib/presentation/library/law_view_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import '../../data/model/law.dart';

class LawViewScreen extends StatelessWidget {
  final Law law;

  LawViewScreen({required this.law});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(law.title)),
      body: PDF().fromUrl(
        law.fileUrl,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}