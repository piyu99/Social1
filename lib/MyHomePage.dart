import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_twitter_google_login/UserData.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future facebookLogin() async {
    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email']);
      try {
        // final FacebookAccessToken accessToken = result.accessToken;
        print('ho');
        navigatetoPage1(
           'Tushar Sharma' , 'https://scontent.fdel11-1.fna.fbcdn.net/v/t1.0-9/45832670_2243903085867308_1998655575130374144_o.jpg?_nc_cat=102&_nc_sid=09cbfe&_nc_ohc=aDRqXi-JPJwAX8qEcan&_nc_ht=scontent.fdel11-1.fna&oh=15afab1396988f51b0ab541428b393be&oe=5F791D95');
        var response = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${result
                .accessToken.token}');

        var responseData = json.decode(response.body);
        print(responseData['picture']['data']['url']);
        print(responseData['id']);
        print('ho');
        navigateToPage(
            responseData['name'], responseData['picture']['data']['url']);
        print('ho');
        insertData(
            responseData['name'],
            responseData['email'],
            responseData['picture']['data']['url'],
            responseData['id'],
            "Facebook");
        // .whenComplete(navigateToPage(responseData['name'],responseData['name']));
      }
      catch(e){
        print(e);
    }
  }

  Future googleLogin() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();

    print("url:${currentUser.photoUrl}");
    print('id:${currentUser.uid}');

    navigateToPage(currentUser.displayName, currentUser.photoUrl);
    insertData(currentUser.displayName, currentUser.email, currentUser.photoUrl,
        currentUser.uid, "Google");
    return 'signInWithGoogle succeeded: $user';
  }

  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: 'j0nrQslOxpIl7th88TKCFsYpZ',
    consumerSecret: '9q5rGPDWkstohM9zq36TPn81viBFynIXuZFJVvqnvWEkHB7B6x',
  );


  void _twitterLogin() async {
    String newMessage;

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        newMessage = 'Logged in! username: ${result.session.username}';
        navigateToPage(result.session.username, '');
        print(result.session.userId);
        insertData(
            result.session.username, '', '', result.session.userId, "Twitter");
        break;
      case TwitterLoginStatus.cancelledByUser:
        newMessage = 'Login cancelled by user.';
        break;
      case TwitterLoginStatus.error:
        newMessage = 'Login error: ${result.errorMessage}';
        break;
    }
  }

  Future insertData(var username, var useremail, var userimage, var userauth,
      var usersource) async {
    var url = "http://localhost/fb_twitter_data/insert_data.php";
    final response = await http.post(url, body: {
      "username": username,
      "useremail": useremail,
      "userimage": userimage,
      "userauth": userauth,
      "usersource": usersource
    });
    print(response.body);
  }
navigatetoPage1(String name, var img){
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => UserData(
            username: name,
            userimage: img,
          )));
}
//  Widget loginButton(var loginText, Function onPress) {
//    return Container(
//
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(40),
//        gradient: new LinearGradient(
//            colors: [
//              const Color(0xFF3366FF),
//              const Color(0xFF00CCFF),
//            ],
//            begin: const FractionalOffset(0.0, 0.0),
//            end: const FractionalOffset(1.0, 0.0),
//            stops: [0.0, 1.0],
//            tileMode: TileMode.clamp),
//      ),
//      height: 40,
//      width: 200,
//      child: MaterialButton(
//        shape: RoundedRectangleBorder(
//            borderRadius: new BorderRadius.circular(18.0),
//            side: BorderSide(color: Colors.black)),
//        onPressed: onPress,
//        splashColor: Colors.black,
//        child: Text(loginText),
//      ),
//    );
//  }

  navigateToPage(var name, var image) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UserData(
                  username: name,
                  userimage: image,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.blue, Colors.indigo,Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
             // stops: [0.9,0.5,0.6,0.8]
            )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 InkWell(
                   radius: 100,
                   splashColor: Colors.blue,
                   focusColor: Colors.blue,
                   child: Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       color: Colors.white,
                     ),
                      width: 250,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Continue with Facebook',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),),
                          SizedBox(
                            width: 10,
                          ),
                          FaIcon(FontAwesomeIcons.facebook)
                        ],
                      ),
                    ),
                   onTap: facebookLogin,
                 ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  radius: 100,
                  splashColor: Colors.blue,
                  focusColor: Colors.blue,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),

                    width: 250,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Continue with Twitter',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),),
                        SizedBox(
                          width: 10,
                        ),
                        FaIcon(FontAwesomeIcons.twitter)
                      ],
                    ),
                  ),
                  onTap: _twitterLogin,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),

                    width: 250,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Log-In with Google',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),),
                        SizedBox(
                          width: 10,
                        ),
                        FaIcon(FontAwesomeIcons.google)
                      ],
                    ),
                  ),
                  onTap: googleLogin,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
