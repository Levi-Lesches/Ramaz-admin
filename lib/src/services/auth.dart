// This class is exported, which allows the API to use a prefix. 
// Otherwise, the whole API would be global!
// ignore_for_file: avoid_classes_with_only_static_members

import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";

typedef VoidCallback = void Function();

class Auth {
	static final FirebaseAuth firebase = FirebaseAuth.instance;
	static final GoogleSignIn google = GoogleSignIn();

	static Future<FirebaseUser> get currentUser async => firebase.currentUser();

	static Future<String> get email async => 
		(await currentUser)?.email;

	static Future<String> get publicationName async => 
		(await (await currentUser)?.getIdToken())?.claims ["publication"];

	static Future<bool> get ready async => await currentUser != null;

	static Future<void> signOut() async {
		await firebase.signOut();
		await google.signOut();
	}

	static Future<GoogleSignInAccount> signIn(
		VoidCallback ifInvalid
	) async {
		if (await ready) { 
			return null;
		}
		final GoogleSignInAccount account = await google.signIn();
		if (account == null) {
			return null;
		}
		else if (!account.email.endsWith("@ramaz.org")) {
			await google.signOut();
			ifInvalid();
			return null;
		}

		final GoogleSignInAuthentication auth = await account.authentication;
		final AuthCredential credential = GoogleAuthProvider.getCredential(
			accessToken: auth.accessToken,
			idToken: auth.idToken,
		);

		await firebase.signInWithCredential(credential);
		return account;
	}
}
