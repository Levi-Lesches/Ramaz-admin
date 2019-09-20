import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/widgets.dart";

import "drawer.dart";

class CalendarPage extends StatelessWidget {
	static const List<String> months = [
		"January", "February", "March", "April", "May", 
		"June", "July", "August", "September", "October",
		"November", "December"
	];
	static const List<String> weekdays = [
		"Sun", "Mon", "Tue", "Wed", "Thur",
		"Fri", "Sat"
	];

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text ("Calendar")),
		drawer: NavDrawer(),
		body: Padding (
			padding: const EdgeInsets.symmetric(horizontal: 5),
			child: ModelListener<CalendarModel, void>(
				model: () => CalendarModel(),
				builder: (CalendarModel model, _, __) => ListView(
					children: [
						SizedBox(
							height: 50,
							child: Row (
								mainAxisAlignment: MainAxisAlignment.spaceAround,
								children: [
									IconButton(
										icon: Icon(Icons.keyboard_arrow_left),
										onPressed: () => model.currentYear -= 1,
									),
									Text ("${model.currentYear}", textScaleFactor: 1.5),
									IconButton(
										icon: Icon(Icons.keyboard_arrow_right),
										onPressed: () => model.currentYear++,
									),
								]
							)
						),
						ExpansionPanelList.radio(
							children: [
								for (int month = 0; month < 12; month++)
									ExpansionPanelRadio(
										value: month,
										canTapOnHeader: true,
										headerBuilder: (_, __) => ListTile(
											title: Text(months [month]),
											trailing: Text(model.getYear(month).toString())
										),
										body: StreamBuilder<DocumentSnapshot>(
											stream: model.getStream(month),
											builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) => 
												!snapshot.hasData
													? const CircularProgressIndicator()
													: SizedBox(
														height: 300,
														child: GridView.count(
															physics: const NeverScrollableScrollPhysics(),
															shrinkWrap: true,
															crossAxisCount: 7, 
															children: [
																for (final String weekday in weekdays) 
																	Center(child: Text (weekday)),
																for (
																	final MapEntry<int, Day> entry in model.getCalendar(
																		month,
																		snapshot
																	)
																) GestureDetector(
																	onTap: entry == null ? null : () async => model.setDay(
																		month: month,
																		date: entry.key,
																		day: await DayBuilder.getDay(
																			context: context, 
																			month: months [month],
																			date: entry.key + 1,
																		)
																	),
																	child: CalendarTile(
																		date: entry?.key,
																		day: entry?.value,
																	),
																)
															]
														)
													)
										)
									)
							]
						)
					]
				)
			)
		)
	);
}
