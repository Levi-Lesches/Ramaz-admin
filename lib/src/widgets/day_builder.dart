import "package:flutter/material.dart";

import "model_listener.dart";
import "services.dart";
import "special_builder.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/models.dart";

class DayBuilder extends StatelessWidget {
	static Future<Day> getDay({
		@required BuildContext context, 
		@required String month, 
		@required int date
	}) => showDialog<Day>(
		context: context, 
		builder: (_) => DayBuilder(month: month, date: date),
	);

	final String month;
	final int date;
	const DayBuilder({
		@required this.month, 
		@required this.date
	});

	@override
	Widget build (BuildContext context) => ModelListener<DayBuilderModel, Null>(
		model: () => DayBuilderModel(Services.of(context).admin),
		child: FlatButton(
			child: Text ("Cancel"),
			onPressed: Navigator.of(context).pop,
		),
		builder: (DayBuilderModel model, [Widget cancel, _]) => AlertDialog(
			title: Text ("Edit day"),
			content: Column (
				mainAxisSize: MainAxisSize.min,
				children: [
					Text ("Date: $month $date"),
					SizedBox(height: 20),
					Container(
						width: double.infinity,
						child: Wrap (
							alignment: WrapAlignment.spaceBetween,
							crossAxisAlignment: WrapCrossAlignment.center,
							children: [
								Text(
									"Select letter", 
									textAlign: TextAlign.center
								),
								DropdownButton<Letter>(
									value: model.letter,
									hint: Text ("Letter"),
									onChanged: (Letter letter) => model.letter = letter,
									items: [
										for (final Letter letter in Letter.values)
											DropdownMenuItem<Letter>(
												value: letter,
												child: Text (letterToString [letter]),
											)
									],
								)
							]
						),
					),
					SizedBox(height: 20),
					Container(
						width: double.infinity,
						child: Wrap (
							runSpacing: 3,
							children: [
								Text ("Select schedule"),
								DropdownButton<Special>(
									value: model.special,
									hint: Text ("Schedule"),
									onChanged: (Special special) async {
										if (special == Special.none) {
											special = await SpecialBuilder.buildSpecial(context);
										}
										model.special = special;
									},
									items: [
										for (final Special special in model.presetSpecials + model.userSpecials)
											DropdownMenuItem<Special>(
												value: special,
												child: Text (special.name),
											),
										DropdownMenuItem<Special>(
											value: Special.none,
											child: SizedBox(
												child: Row(
													children: [
														Text ("Make new schedule"),
														Icon(Icons.add_circle_outline)
													]
												)
											)
										)
									],
								)
							]
						)
					)
				]
			),
			actions: [
				cancel,
				RaisedButton(
					child: Text ("Save", style: TextStyle(color: Colors.white)),
					onPressed: !model.ready ? null :() => 
						Navigator.of(context).pop(model.day)
				)
			]
		),
	);
}
