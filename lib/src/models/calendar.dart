import "package:flutter/foundation.dart" show required, ChangeNotifier;
import "package:flutter/widgets.dart" show AsyncSnapshot;
import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart" as FB;

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/services.dart";

class CalendarModel with ChangeNotifier {
	static const int daysInMonth = 7 * 5;
	static final int currentMonth = DateTime.now().month;


	static List<T> mapToList<T> (Map<int, T> map) {
		final List<T> result = List.filled(map.length, null);
		for (final MapEntry<int, T> entry in map.entries) {
			result [entry.key] = entry.value;
		}
		return result;
	}

	final List<Stream<FB.DocumentSnapshot>> streams = List.filled(12, null);
	final List<AsyncSnapshot<FB.DocumentSnapshot>> snapshots = List.filled(12, null);
	final List<List<MapEntry<int, Day>>> data = List.filled(12, null);
	final List<int> years = List.filled(12, null);

	Iterable<MapEntry<int, Day>> getCalendar(
		int month, 
		AsyncSnapshot<FB.DocumentSnapshot> snapshot
	) {
		if (snapshots [month] == snapshot)
			return data [month];

		snapshots [month] = snapshot;
		final List<MapEntry<int, Day>> newData = getData(month);
		data [month] = newData;
		return newData;
	}

	Stream<FB.DocumentSnapshot> getStream(int index) {
		if (streams [index] != null) return streams [index];

		final Stream<FB.DocumentSnapshot> stream = Firestore.getCalendar(index + 1);
		streams [index] = stream;
		return stream;
	}

	int _currentYear = DateTime.now().year;
	int get currentYear => _currentYear;
	set currentYear (int year) {
		_currentYear = year;
		for (int index = 0; index < 12; index++) {
			data [index] = getData(index);
			years [index] = getYear(index, true);
		}
		notifyListeners();
	}

	void setDay({
		@required int month,
		@required int date,
		@required Day day,
	}) async {
		if (day == null) return;
		final List<MapEntry<int, Day>> entries = data [month];
		Map<int, Day> calendarAsMap = Map.fromEntries(
			entries.where(
				(MapEntry<int, Day> entry) => entry != null
			)
		);
		List<Day> calendar = mapToList(calendarAsMap);
		calendar [date] = day;
		Firestore.saveCalendar(
			month + 1, 
			calendar.where(
				(Day day) => day != null
			).toList().asMap().map(
				(int index, Day day) => MapEntry<String, dynamic>(
					(index + 1).toString(),
					day.toJson(),
				)
			)
		);
	}

	int getYearData(month) {
		if (currentMonth < 7) {
			if (month < 7) return currentYear - 1;
			else return currentYear;
		} else {
			if (month < 7) return currentYear + 1;
			else return currentYear;
		}
	}

	int getYear(int month, [bool force = false]) {
		if (years [month] != null && !force) 
			return years [month];

		final int result = getYearData(month);
		years [month] = result;
		return result;
	}

	List<MapEntry<int, Day>> getData(int month) {
		final List<MapEntry<int, Day>> result = [];
		final List<Day> days = Day.getCalendar(snapshots [month].data.data);
		final int selectedYear = getYear(month);
		final DateTime firstOfMonth = DateTime(selectedYear, month + 1, 1);
		final int firstDayOfWeek = firstOfMonth.weekday;
		final int weekday = firstDayOfWeek == 7
			? 0 : firstDayOfWeek - 1;
		for (int day = 0; day < weekday; day++)
			result.add(null);
		result.addAll(days.asMap().entries);
		for (int day = weekday + days.length; day < daysInMonth; day++)
			result.add(null);
		return result;
	}
}
