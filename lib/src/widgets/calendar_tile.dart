import "package:flutter/material.dart";

import "package:ramaz_admin/data.dart";

class CalendarTile extends StatelessWidget{
	final int date;
	final Day day;

	const CalendarTile({
		@required this.date,
		@required this.day,
	});

	Widget build(BuildContext context) => Container(
		decoration: BoxDecoration(border: Border.all()),
		child: Stack (
			children: [
				if (date != null) ...[ 
					Align (
						alignment: Alignment.topLeft,
						child: Text ((date + 1).toString()),
					),
					if (day.letter != null)
						Center (
							child: Text (
								letterToString [day.letter], 
								textScaleFactor: 1.5
							),
						),
					if (
						day?.letter != null &&
						!<String>[Special.rotate.name, Special.regular.name]
							.contains(day.special?.name ?? null)
					) Align(
						alignment: Alignment.bottomCenter,
						child: Text ("•", textScaleFactor: 0.8),
					)
				]
			]
		)
	);
}
