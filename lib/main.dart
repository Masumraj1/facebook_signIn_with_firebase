import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'firebase_options.dart';


///https://facebook-6bd93.firebaseapp.com/__/auth/handler
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SignInScreen()
    );
  }
}


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: TextButton(onPressed: ()async{

            try{

              final UserCredential userCredential = await signInWithFacebook();
              if (context.mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          displayName: userCredential.user!.displayName!,
                          photoURL: userCredential.user!.photoURL ?? "",
                          email: userCredential.user!.email!,

                        )));}

              print("____=======================_______${userCredential.user!.displayName!}");
            }catch(e){
              print("----------------------------error$e");
            }

          }, child: Container(
              padding: const EdgeInsets.only(top: 5,bottom: 5,left: 20,right: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: Colors.blue
              ),

              child: Row(
                children: [
                  Image.network("https://static-00.iconduck.com/assets.00/facebook-icon-512x512-seb542ju.png",width: 50,height: 40,),
                  const Text("Signin with Facebook"),
                ],
              ))),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}


///------------------------home page for test somethink----------------->
class HomeScreen extends StatelessWidget {
  final String displayName;
  final String photoURL;
  final String email;

  const HomeScreen({
    Key? key,
    required this.displayName,
    required this.photoURL,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("--------------------url : ${photoURL}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (photoURL.isNotEmpty)
              CircleAvatar(
                backgroundImage: NetworkImage(photoURL),
                radius: 50,
              ),
            const SizedBox(height: 20),
            Text('Display Name: $displayName'),
            const SizedBox(height: 10),
            Text('Email: $email'),
          ],
        ),
      ),
    );
  }
}
