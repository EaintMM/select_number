import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SelectNumber(),
    );
  }
}

class SelectNumber extends StatefulWidget {
  const SelectNumber({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectNumberState();
}

class _SelectNumberState extends State<SelectNumber> {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int correctAnswer = 0;
  int score = 0;
  String msg = '';
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    loadScore();
  }

  saveScore(int newScore) async {
    prefs = await SharedPreferences.getInstance();
    await prefs!.setInt("score", newScore);
  }

  loadScore() async {
    prefs = await SharedPreferences.getInstance();
    var myscore = prefs?.getInt("score");
    if (myscore != null) {
      setState(() {
        score = myscore;
      });
    }
  }

  // custom image widget
  Widget imageList(List<int> images) => Column(
        children: images
            .map((e) => InkWell(
                  onTap: () {
                    if (e == correctAnswer) {
                      setState(() {
                        score++;
                        saveScore(score);
                        msg = "Your answer is correct";
                      });
                    } else {
                      setState(() {
                        msg = 'Your answer is not correct';
                      });
                    }
                  },
                  child: Ink(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/$e.png'))),
                  ),
                ))
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    numbers.shuffle();
    List<int> images = numbers.sublist(0, 3);
    correctAnswer = images[0];
    images.shuffle();
    return Scaffold(
        appBar: AppBar(title: const Text('Select Number')),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("select the number $correctAnswer"),
              imageList(images),
              Text(msg),
              TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: (() {
                    setState(() {});
                  }),
                  child: const Text("Refresh")),
              Text('Your score : $score'),
            ],
          )),
        ));
  }
}
