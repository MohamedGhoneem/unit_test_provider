import 'package:flutter/material.dart';
import 'package:unit_test_provider/news_service.dart';

import 'article.dart';

class NewsChangeNotifier extends ChangeNotifier {
  final NewsService _newsService;

  NewsChangeNotifier(this._newsService);

  List<Article> _articles = [];

  List<Article> get articles => _articles;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getArticles() async {
    _isLoading = true;
    notifyListeners();
    _articles = await _newsService.getArticles();
    _isLoading = false;
    notifyListeners();
  }
}
