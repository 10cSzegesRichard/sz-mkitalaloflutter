import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MemoryGameApp());

class MemoryGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MemoryGameScreen(),
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WordPair {
  final String text;
  final int id; // Az összetartozó pároknak ugyanaz az ID-ja
  bool isFlipped = false;
  bool isMatched = false;

  WordPair({required this.text, required this.id});
}

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<WordPair> _cards = [];
  int _moves = 0;
  int _seconds = 0;
  Timer? _timer;
  WordPair? _firstCard;
  bool _wait = false;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    // Szópárok definiálása (ID alapján kapcsolódnak)
    List<WordPair> baseData = [
      WordPair(text: 'Kutya', id: 1),
      WordPair(text: 'Dog', id: 1),
      WordPair(text: 'Macska', id: 2),
      WordPair(text: 'Cat', id: 2),
      WordPair(text: 'Alma', id: 3),
      WordPair(text: 'Apple', id: 3),
      WordPair(text: 'Ház', id: 4),
      WordPair(text: 'House', id: 4),
      WordPair(text: 'Könyv', id: 5),
      WordPair(text: 'Book', id: 5),
      WordPair(text: 'Autó', id: 6),
      WordPair(text: 'Car', id: 6),
      WordPair(text: 'Nap', id: 7),
      WordPair(text: 'Sun', id: 7),
      WordPair(text: 'Víz', id: 8),
      WordPair(text: 'Water', id: 8),
    ];
    _cards = baseData..shuffle(); // Kártyák megkeverése
    _moves = 0;
    _seconds = 0;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
    });
  }

  void _onCardTap(WordPair card) {
    if (_wait || card.isFlipped || card.isMatched) return;

    setState(() {
      card.isFlipped = true;
    });

    if (_firstCard == null) {
      _firstCard = card;
    } else {
      _moves++;
      if (_firstCard!.id == card.id) {
        // Találat!
        _firstCard!.isMatched = true;
        card.isMatched = true;
        _firstCard = null;
        _checkWin();
      } else {
        // Nem talált, visszafordítás kis késleltetéssel
        _wait = true;
        Timer(Duration(milliseconds: 800), () {
          setState(() {
            _firstCard!.isFlipped = false;
            card.isFlipped = false;
            _firstCard = null;
            _wait = false;
          });
        });
      }
    }
  }

  void _checkWin() {
    if (_cards.every((card) => card.isMatched)) {
      _timer?.cancel();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Gratulálok!"),
          content: Text("Idő: $_seconds mp\nLépések: $_moves"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _setupGame());
              },
              child: Text("Új játék"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Szókártya Memória')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Lépések: $_moves', style: TextStyle(fontSize: 18)),
                Text('Idő: $_seconds mp', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                var card = _cards[index];
                return GestureDetector(
                  onTap: () => _onCardTap(card),
                  child: Container(
                    decoration: BoxDecoration(
                      color: card.isFlipped || card.isMatched
                          ? Colors.white
                          : Colors.teal,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      card.isFlipped || card.isMatched ? card.text : '?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: card.isFlipped || card.isMatched
                            ? Colors.teal
                            : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
