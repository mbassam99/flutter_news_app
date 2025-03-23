import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  List articles = [];
  bool isLoading = true;
  String selectedCategory = 'general';
  final List<String> categories = [
    'general', 'business', 'entertainment', 'health', 'science', 'sports', 'technology'
  ];
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
    loadFavorites();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&category=$selectedCategory&apiKey=083a13233c6846e88487ccb9c8093eb8');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> toggleFavorite(String url) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favorites.contains(url)) {
        favorites.remove(url);
      } else {
        favorites.add(url);
      }
    });
    await prefs.setStringList('favorites', favorites);
  }

  Future<void> shareArticle(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News - ${selectedCategory.toUpperCase()}"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                      isLoading = true;
                    });
                    fetchNews();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: selectedCategory == categories[index] ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        categories[index].toUpperCase(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      final isFavorite = favorites.contains(article['url']);
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(article['title'] ?? 'No Title',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text(article['description'] ?? 'No Description'),
                          leading: article['urlToImage'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(article['urlToImage'], width: 100, fit: BoxFit.cover))
                              : SizedBox(width: 100),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                onPressed: () => toggleFavorite(article['url']),
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () => shareArticle(article['url']),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Implement article details page
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}