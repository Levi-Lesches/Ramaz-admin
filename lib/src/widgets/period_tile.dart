import "package:flutter/material.dart";

import "package:ramaz_admin/data.dart";

class PeriodTile extends StatelessWidget {
	final Range range;
	final TimeOfDay start, end;

	final void Function(Range) onChanged;
	final VoidCallback onRemoved, toggleSkip;

	final bool skipped, isHomeroom, isMincha;
	final int index;
	final String subtitle;

	PeriodTile({
		@required this.skipped,
		@required this.range,
		@required this.onChanged,
		@required this.onRemoved,
		@required this.toggleSkip,
		@required this.isHomeroom,
		@required this.isMincha,
		@required this.index,
	}) : 
		assert (!isHomeroom || !isMincha),
		assert (isHomeroom || isMincha || index != null),
		subtitle = isHomeroom ? "Homeroom" : 
			isMincha ? "Mincha" : "$index",
		start = TimeOfDay(hour: range.start.hour, minute: range.start.minute),
		end = TimeOfDay(hour: range.end.hour, minute: range.end.minute);

	@override
	Widget build(BuildContext context) => SizedBox(
		height: 55,
		child: Stack (
			children: [
				if (skipped) Center(
					child: Container(
						height: 5,
						color: Colors.black,	
					),
				),
				ListTile(
					subtitle: Text (subtitle),
					leading: IconButton(
						icon: Icon(Icons.remove_circle_outline),
						onPressed: onRemoved,
					),
					title: Text.rich(
						TextSpan(
							children: [
								WidgetSpan(
									child: InkWell(
										child: Text (start.format(context), style: TextStyle(color: Colors.blue)),
										onTap: () async {
											final TimeOfDay time = await showTimePicker(
												context: context,
												initialTime: start,
											);
											onChanged(
												Range(
													Time(time.hour, time.minute),
													range.end,
												)
											);
										}
									),
								),
								TextSpan(text: " -- "),
								WidgetSpan(
									child: InkWell(
										child: Text (end.format(context), style: TextStyle(color: Colors.blue)),
										onTap: () async {
											final TimeOfDay time = await showTimePicker(
												context: context,
												initialTime: end,
											);
											onChanged(
												Range(
													range.start,
													Time(time.hour, time.minute),
												)
											);
										}
									),
								),
							]
						)
					),
					trailing: FlatButton(
						child: Text (skipped ? "UNSKIP" : "SKIP"),
						onPressed: toggleSkip,
					),
				)
			]
		)
	);
}
