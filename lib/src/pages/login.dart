import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:ramaz_admin/constants.dart";
import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/widgets.dart";

class LoginPage extends StatelessWidget {
	final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: Text ("Login")),
		body: ValueListenableBuilder<bool>(
			valueListenable: loadingNotifier,
			child: Padding (
				padding: EdgeInsets.all(50),
				child: Column (
					children: [
						Text ("Welcome to the Ramaz console!", textScaleFactor: 2),
						SizedBox(height: 30),
						Text ("This app is only for Ramaz administrators and club captains.", textScaleFactor: 1.5),
						SizedBox(height: 50),
						Builder(
							builder: (BuildContext context) => ListTile(
								leading: CircleAvatar(
									backgroundImage: AssetImage("images/google.png"),
									backgroundColor: Theme.of(context).scaffoldBackgroundColor,
								),
								title: Text ("Login"),
								onTap: () => login(context),
							)
						)
					]
				)
			),
			builder: (BuildContext context, bool loading, Widget child) => Column (
				children: [
					if (loading) LinearProgressIndicator(),
					Spacer(flex: 1),
					child,
					Spacer(flex: 1)
				]
			)
		)
	);

	void showError(BuildContext context) => showDialog(
		context: context,
		builder: (_) => AlertDialog(
			title: Text ("Login failed"),
			content: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Text (
						"Could not log into your account",
						textScaleFactor: 1.5,
					),
					SizedBox(height: 10),
					Text(
						"A problem prevented you from logging in. "
						"Please contact Levi Lesches ('21) or someone "
						"from IT for help."
					)
				],
			),
			actions: [
				RaisedButton(
					child: Text (
						"Close",
						style: TextStyle(color: Colors.white),
					),
					onPressed: Navigator.of(context).pop,
				)
			]
		)
	);

	void login(BuildContext context) async {
		try {
			loadingNotifier.value = true;
			final account = await Auth.signIn(
				() => Scaffold.of(context).showSnackBar(
					SnackBar(
						content: Text ("Please sign in with a Ramaz Google account"),
					)
				)
			);
			if (account == null) {
				loadingNotifier.value = false;
				return;
			}
			await Services.of(context).services.login();
			loadingNotifier.value = false;
			Navigator.of(context).pushReplacementNamed(Routes.home);
		} on PlatformException catch (error) {
			loadingNotifier.value = false;
			if (
				error.code == "sign_in_failed" || 
				error.message == "Failed to get document because the client is offline."
			) Scaffold.of(context).showSnackBar(
				SnackBar(
					content: Text ("No internet"),
				)
			); else {
				print ("ERROR: ${error.code}");
				showError(context);
				rethrow;
			}
		} catch (error) {
			loadingNotifier.value = false;
			if (!(error is NoSuchMethodError))
				print ("ERROR: ${error.code}");
			showError(context);
			rethrow;
		}
	}
}
