import 'package:flutter/material.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizScreen(),
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _totalScore = 0;

  // Kérdések és válaszok listája
  final List<Map<String, Object>> _questions = [
    {
      'questionText': 'Melyik nyelven íródik a Flutter?',
      'answers': [
        {'text': 'Java', 'score': 0},
        {'text': 'Dart', 'score': 10},
        {'text': 'Python', 'score': 0},
        {'text': 'C#', 'score': 0},
      ],
    },
    {
      'questionText': 'Ki fejlesztette a Fluttert?',
      'answers': [
        {'text': 'Facebook', 'score': 0},
        {'text': 'Apple', 'score': 0},
        {'text': 'Google', 'score': 10},
        {'text': 'Microsoft', 'score': 0},
      ],
    },
    {
      'questionText': 'Mire való a Widget a Flutterben?',
      'answers': [
        {'text': 'Csak gombok készítésére', 'score': 0},
        {'text': 'Adatbázis kezelésre', 'score': 0},
        {'text': 'Minden UI elem egy Widget', 'score': 10},
        {'text': 'Hálózati hívásokhoz', 'score': 0},
      ],
    },
  ];

  void _answerQuestion(int score) {
    setState(() {
      _totalScore += score;
      _questionIndex++;
    });
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Kvíz')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _questionIndex < _questions.length
            ? Column(
                children: [
                  // Kérdés szövege
                  Text(
                    _questions[_questionIndex]['questionText'] as String,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Válasz gombok generálása
                  ...(_questions[_questionIndex]['answers']
                          as List<Map<String, Object>>)
                      .map((answer) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(answer['text'] as String),
                            onPressed: () =>
                                _answerQuestion(answer['score'] as int),
                          ),
                        );
                      })
                      .toList(),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vége a kvíznek!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Pontszámod: $_totalScore / ${_questions.length * 10}',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: _resetQuiz,
                      child: Text('Újratöltés', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
