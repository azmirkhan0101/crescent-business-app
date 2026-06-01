import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninService {
  final _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  GoogleSigninService() {
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      //await _googleSignIn.initialize(serverClientId: "279971282218-kbv6uk6nr362lgca2u1c3scoph5p713c.apps.googleusercontent.com");
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
    }
  }

  //Always check Google sign in initialization before use
  Future<void> _ensureGoogleSignInInitialized() async {
    if ( !_isGoogleSignInInitialized ) {
      await _initializeGoogleSignIn();
    }
  }

  Future<GoogleSignInAccount> signInWithGoogle() async{
    await _ensureGoogleSignInInitialized();
    try{
      GoogleSignInAccount signInAccount = await _googleSignIn.authenticate(scopeHint: ['email']);
      return signInAccount;
    }on GoogleSignInException catch(e){
      rethrow;
    }catch(e){
      rethrow;
    }
  }

  GoogleSignInAuthentication getAuthTokens(GoogleSignInAccount account) {
    return account.authentication;
  }
}
