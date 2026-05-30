import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Quotes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const QuoteHomePage(),
    );
  }
}

class QuoteHomePage extends StatefulWidget {
  const QuoteHomePage({super.key});

  @override
  State<QuoteHomePage> createState() => _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage> {
  // Sample quotes - in a real app, you might fetch these from an API or database
  final List<Quote> _quotes = [
    Quote(
      text: "The only way to do great work is to love what you do.",
      author: "Steve Jobs",
    ),
    Quote(
      text: "Life is what happens when you're busy making other plans.",
      author: "John Lennon",
    ),
    Quote(
      text: "The future belongs to those who believe in the beauty of their dreams.",
      author: "Eleanor Roosevelt",
    ),
    Quote(
      text: "In the middle of difficulty lies opportunity.",
      author: "Albert Einstein",
    ),
    Quote(
      text: "Believe you can and you're halfway there.",
      author: "Theodore Roosevelt",
    ),
  ];

  late Quote _currentQuote;
  List<Quote> _favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    _getRandomQuote();
  }

  void _getRandomQuote() {
    final random = Random();
    setState(() {
      _currentQuote = _quotes[random.nextInt(_quotes.length)];
    });
  }

  void _toggleFavorite() {
    setState(() {
      if (_favoriteQuotes.contains(_currentQuote)) {
        _favoriteQuotes.remove(_currentQuote);
      } else {
        _favoriteQuotes.add(_currentQuote);
      }
    });
  }

  void _shareQuote() {
    Share.share('"${_currentQuote.text}" - ${_currentQuote.author}');
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite = _favoriteQuotes.contains(_currentQuote);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Inspiration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(favorites: _favoriteQuotes),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Quote of the Day',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        '"${_currentQuote.text}"',
                        style: const TextStyle(
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "- ${_currentQuote.author}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                      size: 30,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      size: 30,
                    ),
                    onPressed: _shareQuote,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getRandomQuote,
        tooltip: 'New Quote',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final List<Quote> favorites;

  const FavoritesPage({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Quotes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No favorite quotes yet!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"${favorites[index].text}"',
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "- ${favorites[index].author}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quote && other.text == text && other.author == author;
  }

  @override
  int get hashCode => text.hashCode ^ author.hashCode;
}