import "package:flutter/material.dart";

enum IssueAction {
	delete,
	view,
	replace,
}

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
									title: Text (getDateAsString(issue)),
									trailing: PopupMenuButton<IssueAction>(
										icon: Icon(Icons.more_vert),
										onSelected: (IssueAction action) {
											switch (action) {
												case IssueAction.delete: deleteIssue(issue); break;
												case IssueAction.replace: replaceIssue(issue); break;
												case IssueAction.view: openIssue(issue); break;
											}
										},
										itemBuilder: (BuildContext context) => const [
											PopupMenuItem<IssueAction>(
												value: IssueAction.view,
												child: Text("View issue"),
											),
											PopupMenuItem(
												value: IssueAction.replace,
												child: Text("Replace issue"),
											),
											PopupMenuItem(
												value: IssueAction.delete,
												child: Text("Delete issue"),
											)
										]
									)
								)
						]
					)
				)
		],
	);
}
