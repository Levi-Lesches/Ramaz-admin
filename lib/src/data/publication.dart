import "package:flutter/foundation.dart";

@immutable
class PublicationMetadata {
	static Map<int, Map<int, List<String>>> getIssuesByMonth(Set<String> issues) {
		final Map<int, Map<int, List<String>>> result = {};
		for (final String issue in issues) {
			final List<String> parts = issue.substring(
				issue.lastIndexOf("/"),
				issue.length - 4,
			).split("_");
			final int year = int.parse(parts [0]);
			final int month = int.parse(parts [1]);
			final Map<int, List<String>> issuesByYear = result [year] ?? [];
			if (issuesByYear.isEmpty) {
				result [year] = issuesByYear;
			}

			final List<String> issuesByMonth = issuesByYear [month] ?? [];
			if (issuesByMonth.isEmpty) {
				issuesByYear [month] = issuesByMonth;
			}

			issuesByMonth.add(issue);
		}

		return result;
	}

	final String description;
	final String imagePath;
	final Set<String> issues;
	final Map<int, Map<int, List<String>>> issuesByMonth;

	PublicationMetadata({
		@required this.description,
		@required this.imagePath,
		@required this.issues,
	}) : issuesByMonth = getIssuesByMonth(issues);

	PublicationMetadata.fromJson(Map<String, String> json) : 
		description = json ["description"],
		imagePath = json ["imagePath"],
		issues = Set.of(json ["issues"].split(", ")),
		issuesByMonth = getIssuesByMonth(Set.of(json ["issues"].split(", ")));

	Map<String, String> toJson() => {
		"description": description,
		"imagePath": imagePath,
		"issues": issues.join(", ")
	};
}

@immutable
class Publication {
	final String name;
	final Set<String> downloadedIssues;
	final PublicationMetadata metadata;

	const Publication({
		@required this.name,
		@required this.downloadedIssues,
		@required this.metadata,
	});
}
