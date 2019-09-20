import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:ramaz_admin/constants.dart";
import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/widgets.dart";

class LoginPage extends StatelessWidget {
	final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text ("Login")),
		body: ValueListenableBuilder<bool>(
			valueListenable: loadingNotifier,
			builder: (BuildContext context, bool loading, Widget child) => Column (
				children: [
					if (loading) const LinearProgressIndicator(),
					const Spacer(flex: 1),
					child,
					const Spacer(flex: 1)
				]
			),
			child: Padding (
				padding: const EdgeInsets.all(50),
				child: Column (
					children: [
						const Text ("Welcome to the Ramaz console!", textScaleFactor: 2),
						const SizedBox(height: 30),
						const Text (
							"This app is only for Ramaz administrators and club captains.", 
							textScaleFactor: 1.5
						),
						const SizedBox(height: 50),
						Builder(
							builder: (BuildContext context) => ListTile(
								leading: CircleAvatar(
									backgroundImage: const AssetImage("images/google.png"),
									backgroundColor: Theme.of(context).scaffoldBackgroundColor,
								),
								title: const Text ("Login"),
								onTap: () => login(context),
							)
						)
					]
				)
			),
		)
	);

	void showError(BuildContext context) => showDialog(
		context: context,
		builder: (_) => AlertDialog(
			title: const Text ("Login failed"),
			content: Column(
				mainAxisSize: MainAxisSize.min,
				children: const [
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
					onPressed: () => Navigator.of(context).pop(),
					child: const Text (
						"Close",
						style: TextStyle(color: Colors.white),
					),
				)
			]
		)
	);

	Future<void> login(BuildContext context) async {
		try {
			loadingNotifier.value = true;
			final account = await Auth.signIn(
				() => Scaffold.of(context).showSnackBar(
					const SnackBar(
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
			await Navigator.of(context).pushReplacementNamed(Routes.home);
		} on PlatformException catch (error) {
			loadingNotifier.value = false;
			if (
				error.code == "sign_in_failed" || 
				error.message == "Failed to get document because the client is offline."
			) {
				Scaffold.of(context).showSnackBar(
					const SnackBar(
						content: Text ("No internet"),
					)
				); 
			} else {
				showError(context);
				rethrow;
			}
		} on Exception catch (error) {
			loadingNotifier.value = false;
			if (error is! NoSuchMethodError) {
				showError(context);
			}
			rethrow;
		}
	}
}
