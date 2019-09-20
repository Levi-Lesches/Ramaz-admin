import "package:flutter/material.dart";

import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/widgets.dart";

import "drawer.dart";

class SpecialPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ModelListener<AdminModel, void>(
		model: () => Services.of(context).admin,
		dispose: false,
		builder: (AdminModel model, _, __) => Scaffold(
			drawer: NavDrawer(),
			appBar: AppBar(
				title: const Text("Custom schedules"),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () async => model.addSpecial(
					await SpecialBuilder.buildSpecial(context),
				),
				child: Icon(Icons.add),
			),
			body: Padding(
				padding: const EdgeInsets.all(20), 
				child: model.admin.specials.isEmpty
					? const Center (
						child: Text (
							"You don't have any schedules yet, but you can make one!",
							textScaleFactor: 1.5,
							textAlign: TextAlign.center,
						)
					)
					: ListView(
						children: [
							for (int index = 0; index < model.admin.specials.length; index++)
								ListTile(
									title: Text (model.admin.specials [index].name),
									trailing: IconButton(
										icon: Icon(Icons.remove_circle),
										onPressed: () => model.removeSpecial(index),
									),
									onTap: () async => model.replaceSpecial(
										index, 
										await SpecialBuilder.buildSpecial(
											context, 
											model.admin.specials [index]
										),
									)
								)
						]
				)
			)
		)
	);
}

