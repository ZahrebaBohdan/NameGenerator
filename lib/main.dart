import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:namegenerator/provider/google_sign_in.dart';
import 'package:namegenerator/sign_up.dart';
import 'package:namegenerator/wordPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return MyHome();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          return SignUp();
        }
      },
    );
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Name Generator',
          theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 187, 222, 251),
              foregroundColor: Colors.black,
            ),
          ),
          home: RandomWords(),
        ));
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final suggestions = [];
  final saved = <WordPair>{};
  final biggerFont = const TextStyle(fontSize: 18.0);
  int index = 0;
  // Stream<List<String>> readFavourites() => FirebaseFirestore.instance.collection('Favourites')
  // .snapshots()
  // .map((snapshot) => snapshot.docs.map((doc) => );

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildSuggestions(),
      favourites(saved.iterator),
      profile(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Name Generator'),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorColor: Colors.blue[200],
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                size: 28,
              ),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite_border_outlined,
                size: 28,
              ),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                size: 28,
              ),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: screens[index],
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = saved.contains(pair);
    final docFavourites = FirebaseFirestore.instance.collection('favourites');

    return ListTile(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WordPage(pair)));
      },
      title: Text(
        pair.asPascalCase,
        style: biggerFont,
      ),
      trailing: GestureDetector(
        onTap: () async {
          if (alreadySaved) {
            setState(() {
              saved.remove(pair);
            });
            await docFavourites.doc().delete();
          } else {
            setState(() {
              saved.add(pair);
            });
            await docFavourites.add(
              {
                'wordpair': '$pair',
              },
            );
          }
        },
        child: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
          semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider(color: Color(0xFFBBDEFB));
        }
        // The syntax "i ~/ 2" divides i by 2 and returns an
        // integer result.
        final index = i ~/ 2;
        // If you've reached the end of the available word
        // pairings...
        if (index >= suggestions.length) {
          // ...then generate 10 more and add them to the
          // suggestions list.
          suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(suggestions[index]);
      },
    );
  }

  Widget favourites(pair) {
    if (saved.isEmpty) {
      return Center(
        child: Text(
          'Empty',
          style: TextStyle(
              fontSize: 30,
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w400),
        ),
      );
    }
    final tiles = saved.map(
      (pair) {
        final alreadySaved = saved.contains(pair);

        return ListTile(
          onTap: (() => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordPage(pair),
                ),
              )),
          title: Text(
            pair.asPascalCase,
            style: biggerFont,
          ),
          trailing: GestureDetector(
            onTap: () {
              setState(
                () {
                  const Icon(Icons.favorite_border);
                  saved.remove(pair);
                },
              );
            },
            child: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
          ),
        );
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(
                context: context, tiles: tiles, color: Colors.blue[200])
            .toList()
        : <Widget>[];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: divided,
    );
  }

  Widget profile() {
    final user = FirebaseAuth.instance.currentUser!;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
          ),
          const Text(''),
          Text(
            'Name: ' + user.displayName!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(''),
          Text(
            'Name: ' + user.email!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(''),
          Text(
            'Verified: ' + user.emailVerified.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
              backgroundColor: MaterialStateProperty.all(Colors.blue.shade50),
              minimumSize: MaterialStateProperty.all(const Size(100, 45)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            child: const Text('Log Out'),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
          ),
        ],
      ),
    );
  }
}
