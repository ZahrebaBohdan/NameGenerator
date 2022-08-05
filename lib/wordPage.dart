import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:namegenerator/main.dart';

class WordPage extends StatefulWidget {
  final WordPair? pair;
  WordPage(this.pair);

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            color: Colors.blue[100],
            child: Column(
              children: [
                Row(children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded))
                ]),
                const SizedBox(height: 250),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(children: [
                      Text(
                        '${widget.pair}',
                        style: const TextStyle(fontSize: 70),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 45,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.share),
                            style: ButtonStyle(
                                shadowColor:
                                    MaterialStateProperty.all(Colors.white),
                                overlayColor:
                                    MaterialStateProperty.all(Colors.blue[100]),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () => null,
                            label: const Text(
                              'Share',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        SizedBox(
                          height: 45,
                          child:ElevatedButton.icon(
                            icon: const Icon(Icons.favorite,color: Colors.red,),
                            style: ButtonStyle(
                                shadowColor:
                                    MaterialStateProperty.all(Colors.white),
                                overlayColor:
                                    MaterialStateProperty.all(Colors.blue[100]),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () => null,
                            label: const Text('Like'),
                        ),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
