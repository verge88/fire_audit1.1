// lib/presentation/library/library_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'dart:convert';
import '../../data/model/law.dart';
import '../../data/repositories/library_repo.dart';
import 'law_view_screen.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}




class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Law>> futureLaws;
  final String url = 'https://firebasestorage.googleapis.com/v0/b/quiz-4c367.appspot.com/o/law_url%2Flaw_url.json?alt=media&token=9e808335-ee2b-45f4-b8e7-dde2aa024d1f';

  @override
  void initState() {
    super.initState();
    futureLaws = _fetchLaws();
  }

  Future<List<Law>> _fetchLaws() async {
    // Initialize a CacheManager
    DefaultCacheManager cacheManager = DefaultCacheManager();

    // Check if the list of laws is cached
    FileInfo? fileInfo = await cacheManager.getFileFromCache(url);
    if (fileInfo != null && fileInfo.validTill!.isAfter(DateTime.now()) ?? false) {
      // If cached data is valid, parse and return it
      String? jsonString = await fileInfo?.file.readAsString();
      Iterable decoded = jsonDecode(jsonString!);
      return List<Law>.from(decoded.map((lawJson) => Law.fromJson(lawJson)));
    } else {
      // Fetch from network if not cached or cache expired
      List<Law> laws = await _fetchFromNetwork();
      // Cache the fetched data
      await cacheManager.putFile(url, utf8.encode(jsonEncode(laws)));
      return laws;
    }
  }

  Future<List<Law>> _fetchFromNetwork() async {
    LibraryDataRepository repository = LibraryDataRepository(url);
    return repository.getLaws();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Библиотека')),
      body: FutureBuilder<List<Law>>(
        future: futureLaws,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No laws available.'));
          }

          List<Law> laws = snapshot.data!;
          return ListView.builder(
            itemCount: laws.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(laws[index].title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawViewScreen(law: laws[index]),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
