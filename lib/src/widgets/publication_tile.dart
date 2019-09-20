import "package:flutter/material.dart";

class PublicationMonthsList extends StatelessWidget {
	static const List<String> months = [
		"Jan", "Feb", "Mar", "Apr", "May", "Jun", 
		"Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
	];

	static String getDateAsString(String issue) {
		final List<String> parts = issue
			.substring(
				issue.lastIndexOf("/") + 1, 
				issue.length - 4
			).split("_");

		final int month = int.parse(parts [1]);
		final int date = int.parse(parts [2]);
		return "${months [month]} $date";
	}

	final Map<int, Map<int, List<String>>> issues;
	final void Function(String) openIssue, deleteIssue, replaceIssue;

	const PublicationMonthsList({
		@required this.issues,
		@required this.openIssue,
		@required this.deleteIssue,
		@required this.replaceIssue,
	});

	@override
	Widget build(BuildContext context) => ExpansionPanelList.radio(
		children: [
			for (final MapEntry<int, Map<int, List<String>>> yearEntry in issues.entries)
				for (
					final MapEntry<int, List<String>> monthEntry
					in yearEntry.value.entries
				) ExpansionPanelRadio(
					canTapOnHeader: true,
					value: "${yearEntry.key}-${monthEntry.key}",
					headerBuilder: (_, __) => ListTile(
						title: Text (
							"${months [monthEntry.key]} ${yearEntry.key}"
						),
					),
					body: Column (
						children: [
							for (final String issue in monthEntry.value)
								ListTile(
									leading: IconButton (
										icon: Icon (Icons.remove_circle_outline),
										onPressed: () => deleteIssue(issue),
									),
									title: Text (getDateAsString(issue)),
									onTap: () => replaceIssue(issue),
									trailing: IconButton (
										icon: Icon(Icons.keyboard_arrow_right),
										onPressed: () => openIssue(issue),
									),
								)
						]
					)
				)
		],
	);
}
