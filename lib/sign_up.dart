import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:namegenerator/main.dart';
import 'package:namegenerator/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/logo.png',
                            width: 200,
                            height: 200,
                          ),
                        ),
                        Spacer(flex: 1),
                        Text(
                          'Create Profile',
                          style: TextStyle(fontSize: 30),
                        ),
                        Spacer(flex: 1),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blue.shade200),
                                minimumSize:
                                    MaterialStateProperty.all(Size(180, 45)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ))),
                            icon: FaIcon(FontAwesomeIcons.google),
                            label: Text('Sign In'),
                            onPressed: () {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              provider.googleLogin();
                              print('Pressed Sign In');
                            },
                          ),
                        ),
                        // ElevatedButton.icon(
                        //     style: ButtonStyle(
                        //         foregroundColor:
                        //             MaterialStateProperty.all(Colors.black),
                        //         backgroundColor: MaterialStateProperty.all(
                        //             Colors.blue.shade50),
                        //         minimumSize:
                        //             MaterialStateProperty.all(Size(180, 45)),
                        //         shape: MaterialStateProperty.all<
                        //                 RoundedRectangleBorder>(
                        //             RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(15.0),
                        //         ))),
                        //     icon: Icon(Icons.arrow_forward_ios_rounded),
                        //     label: Text('Continue'),
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => MyHome(),
                        //           ));
                        //     }),
                        // Spacer(flex: 1),
                        Spacer(),
                      ]),
                ),
              ),
            ),
          ),
        ));
  }
}
