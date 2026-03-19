import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const SzamkitalaloApp());
}

class SzamkitalaloApp extends StatelessWidget {
  const SzamkitalaloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Kikapcsoljuk a debug feliratot
      title: 'Számkitaláló Játék',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const JatekOldal(),
    );
  }
}

class JatekOldal extends StatefulWidget {
  const JatekOldal({super.key});

  @override
  State<JatekOldal> createState() => _JatekOldalState();
}

class _JatekOldalState extends State<JatekOldal> {
  final TextEditingController _controller = TextEditingController();
  late int _titkosSzam;
  int _tippekSzama = 0;
  String _uzenet = "Gondoltam egy számra 1 és 100 között!";
  bool _nyert = false;

  @override
  void initState() {
    super.initState();
    _ujJatek();
  }

  void _ujJatek() {
    setState(() {
      _titkosSzam = Random().nextInt(100) + 1;
      _tippekSzama = 0;
      _uzenet = "Tippelj egy számra 1 és 100 között!";
      _nyert = false;
      _controller.clear();
    });
  }

  void _ellenorzes() {
    final int? tipp = int.tryParse(_controller.text);

    if (tipp == null) {
      setState(() => _uzenet = "Kérlek, érvényes számot adj meg!");
      return;
    }

    setState(() {
      _tippekSzama++;
      if (tipp < _titkosSzam) {
        _uzenet = "Nagyobb számra gondoltam! ↑";
      } else if (tipp > _titkosSzam) {
        _uzenet = "Kisebb számra gondoltam! ↓";
      } else {
        _uzenet = "Gratulálok! 🎉\nEltaláltad $_tippekSzama tippből!";
        _nyert = true;
      }
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Számkitaláló"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        // Vízszintes középre igazítás a teljes képernyőn
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Függőleges középre igazítás
            crossAxisAlignment:
                CrossAxisAlignment.center, // Tartalom vízszintes középre
            children: [
              Text(
                _uzenet,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                "Eddigi próbálkozások: $_tippekSzama",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 40),

              if (!_nyert) ...[
                // Tippelés közbeni felület
                SizedBox(
                  width: 250, // Ne legyen túl széles a beviteli mező
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign:
                        TextAlign.center, // A beírt szám is középen legyen
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Szám helye',
                    ),
                    onSubmitted: (_) => _ellenorzes(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _ellenorzes,
                  icon: const Icon(Icons.send),
                  label: const Text("Ellenőrzés"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
              ] else ...[
                // Győzelem utáni felület - ez is teljesen középen jelenik meg
                const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _ujJatek,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Új játék indítása"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
