import "package:flutter/material.dart";

import "drawer.dart";

import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/widgets.dart";

class SpecialPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ModelListener<AdminModel, Null>(
		model: () => Services.of(context).admin,
		dispose: false,
		builder: (AdminModel model, _, __) => Scaffold(
			drawer: NavDrawer(),
			appBar: AppBar(
				title: Text("Custom schedules"),
			),
			floatingActionButton: FloatingActionButton(
				child: Icon(Icons.add),
				onPressed: () async => model.addSpecial(
					await SpecialBuilder.buildSpecial(context),
				),
			),
			body: Padding(
				padding: EdgeInsets.all(20), 
				child: model.admin.specials.length == 0
					? Center (
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

