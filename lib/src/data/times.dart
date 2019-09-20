import "package:flutter/foundation.dart" show immutable;

enum Letter {A, B, C, M, R, E, F}

const Map<String, Letter> stringToLetter = {
	"A": Letter.A,
	"B": Letter.B,
	"C": Letter.C,
	"M": Letter.M,
	"R": Letter.R,
	"E": Letter.E,
	"F": Letter.F
};

const Map<Letter, String> letterToString = {
	Letter.A: "A",
	Letter.B: "B",
	Letter.C: "C",
	Letter.M: "M",
	Letter.R: "R",
	Letter.E: "E",
	Letter.F: "F"
};

@immutable
class Time {
	final int hour, minute;

	const Time(this.hour, this.minute);

	Time.fromJson(Map<String, dynamic> json) :
		hour = json ["hour"],
		minute = json ["minutes"];

	Map<String, dynamic> toJson() => {
		"hour": hour,
		"minutes": minute,
	};

	@override
	int get hashCode => "$hour:$minute".hashCode;

	@override 
	bool operator == (dynamic other) => 
		hour == other.hour && minute == other.minute;

	bool operator < (dynamic other) => hour == other.hour
		? minute < other.minute
		: hour < other.hour;

	bool operator <= (dynamic other) => this == other || this < other;

	bool operator > (dynamic other) => hour == other.hour
		? minute > other.minute
		: hour > other.hour;

	bool operator >= (dynamic other) => this == other || this > other;
}

@immutable
class Range {
	final Time start, end;
	const Range (this.start, this.end);

	Range.fromJson(Map<String, dynamic> json) :
		start = Time.fromJson(Map<String, dynamic>.from(json ["start"])),
		end = Time.fromJson(Map<String, dynamic>.from(json ["end"]));

	Map<String, dynamic> toJson() => {
		"start": start.toJson(),
		"end": end.toJson(),
	};
}

@immutable
class Special {
	final List<Range> periods;
	final List<int> skip;
	final String name;
	final int mincha, homeroom;

	const Special (
		this.name,
		this.periods,
		{
			this.homeroom,
			this.mincha,
			this.skip,
		}
	);

	static const Special none = Special(null, null);

	Special.fromJson(Map<String, dynamic> json) :
		periods = [
			for (dynamic period in json ["periods"])
				Range.fromJson(Map<String, dynamic>.from(period))
		],
		skip = List<int>.from(json ["skip"]),
		name = json ["name"],
		mincha = json ["mincha"],
		homeroom = json ["homeroom"];

	static bool deepEquals<E>(List<E> a, List<E> b) {
		if (a.length != b.length) {
			return false;
		}
		for (int index = 0; index < a.length; index++) {
			if (a [index] != b [index]) { 
				return false;
			}
		}
		return true;
	}

	@override
	bool operator == (Object other) =>other is Special && 
		!(other.name == null || name == null) &&
		deepEquals<Range> (other.periods ?? [], periods ?? []) && 
		deepEquals<int>(other.skip ?? [], skip ?? []) &&
		other.name == name &&
		other.mincha == mincha &&
		other.homeroom == homeroom;
		
	@override 
	int get hashCode => name.hashCode;

	Map<String, dynamic> toJson() => {
		"periods": [
			for (final Range period in periods)
				period.toJson(),
		],
		"skip": skip,
		"name": name,
		"mincha": mincha,
		"homeroom": homeroom,
	};

	static const List<Special> specialList = [
		regular,
		rotate,
		friday,
		winterFriday,

		roshChodesh,
		fridayRoshChodesh,
		winterFridayRoshChodesh,
		fastDay,

		amAssembly,
		pmAssembly,
		early,
	];

	static final Map<String, Special> stringToSpecial = Map.fromIterable(
		specialList,
		key: (special) => special.name,
	);

	static const Special roshChodesh = Special(
		"Rosh Chodesh",
		[
			Range (Time (8, 00), Time (9, 05)),
			Range (Time (9, 10), Time (9, 50)),
			Range (Time (9, 55), Time (10, 35)),
			Range (Time (10, 35), Time (10, 50)),
			Range (Time (10, 50), Time (11, 30)), 
			Range (Time (11, 35), Time (12, 15)),
			Range (Time (12, 20), Time (12, 55)),
			Range (Time (1, 00), Time (1, 35)),
			Range (Time (1, 40), Time (2, 15)),
			Range (Time (2, 30), Time (3, 00)),
			Range (Time (3, 00), Time (3, 20)),
			Range (Time (3, 20), Time (4, 00)),
			Range (Time (4, 05), Time (4, 45))
		],
		homeroom: 3,
		mincha: 10,
	);

	static const Special fastDay = Special(
		"Tzom",
		[
			Range (Time (8, 00), Time (8, 55)),
			Range (Time (9, 00), Time (9, 35)),
			Range (Time (9, 40), Time (10, 15)),
			Range (Time (10, 20), Time (10, 55)), 
			Range (Time (11, 00), Time (11, 35)), 
			Range (Time (11, 40), Time (12, 15)),
			Range (Time (12, 20), Time (12, 55)), 
			Range (Time (1, 00), Time (1, 35)), 
			Range (Time (1, 35), Time (2, 05))
		],
		mincha: 8,
		skip: [6, 7, 8]
	);

	static const Special friday = Special (
		"Friday",
		[
			Range (Time (8, 00), Time (8, 45)),
			Range (Time (8, 50), Time (9, 30)),
			Range (Time (9, 35), Time (10, 15)),
			Range (Time (10, 20), Time (11, 00)),
			Range (Time (11, 00), Time (11, 20)),
			Range (Time (11, 20), Time (12, 00)),
			Range (Time (12, 05), Time (12, 45)),
			Range (Time (12, 50), Time (1, 30))
		],
		homeroom: 4
	);

	static const Special fridayRoshChodesh = Special (
		"Friday Rosh Chodesh",
		[
			Range(Time (8, 00), Time (9, 05)),
			Range(Time (9, 10), Time (9, 45)),
			Range(Time (9, 50), Time (10, 25)),
			Range(Time (10, 30), Time (11, 05)),
			Range(Time (11, 05), Time (11, 25)),
			Range(Time (11, 25), Time (12, 00)),
			Range(Time (12, 05), Time (12, 40)),
			Range(Time (12, 45), Time (1, 20))
		],
		homeroom: 4
	);

	static const Special winterFriday = Special (
		"Winter Friday",
		[
			Range(Time (8, 00), Time (8, 45)),
			Range(Time (8, 50), Time (9, 25)), 
			Range(Time (9, 30), Time (10, 05)), 
			Range(Time (10, 10), Time (10, 45)),
			Range(Time (10, 45), Time (11, 05)), 
			Range(Time (11, 05), Time (11, 40)),
			Range(Time (11, 45), Time (12, 20)),
			Range(Time (12, 25), Time (1, 00))
		],
		homeroom: 4
	);

	static const Special winterFridayRoshChodesh = Special (
		"Winter Friday Rosh Chodesh",
		[
			Range(Time (8, 00), Time (9, 05)),
			Range(Time (9, 10), Time (9, 40)),
			Range(Time (9, 45), Time (10, 15)),
			Range(Time (10, 20), Time (10, 50)), 
			Range(Time (10, 50), Time (11, 10)),
			Range(Time (11, 10), Time (11, 40)),
			Range(Time (11, 45), Time (12, 15)),
			Range(Time (12, 20), Time (12, 50))
		],
		homeroom: 4
	);

	static const Special amAssembly = Special (
		"AM Assembly",
		[
			Range(Time (8, 00), Time (8, 50)),
			Range(Time (8, 55), Time (9, 30)),
			Range(Time (9, 35), Time (10, 10)),
			Range(Time (10, 10), Time (11, 10)),
			Range(Time (11, 10), Time (11, 45)), 
			Range(Time (11, 50), Time (12, 25)),
			Range(Time (12, 30), Time (1, 05)),
			Range(Time (1, 10), Time (1, 45)),
			Range(Time (1, 50), Time (2, 25)),
			Range(Time (2, 30), Time (3, 05)),
			Range(Time (3, 05), Time (3, 25)), 
			Range(Time (3, 25), Time (4, 00)),
			Range(Time (4, 05), Time (4, 45))
		],
		homeroom: 3,
		mincha: 10
	);

	static const Special pmAssembly = Special (
		"PM Assembly",
		[
			Range(Time (8, 00), Time (8, 50)), 
			Range(Time (8, 55), Time (9, 30)),
			Range(Time (9, 35), Time (10, 10)),
			Range(Time (10, 15), Time (10, 50)),
			Range(Time (10, 55), Time (11, 30)),
			Range(Time (11, 35), Time (12, 10)),
			Range(Time (12, 15), Time (12, 50)),
			Range(Time (12, 55), Time (1, 30)),
			Range(Time (1, 35), Time (2, 10)), 
			Range(Time (2, 10), Time (3, 30)),
			Range(Time (3, 30), Time (4, 05)),
			Range(Time (4, 10), Time (4, 45))
		],
		mincha: 9
	);

	static const Special regular = Special (
		"M or R day",
		[
			Range(Time (8, 00), Time (8, 50)),
			Range(Time (8, 55), Time (9, 35)),
			Range(Time (9, 40), Time (10, 20)),
			Range(Time (10, 20), Time (10, 35)),
			Range(Time (10, 35), Time (11, 15)), 
			Range(Time (11, 20), Time (12, 00)),
			Range(Time (12, 05), Time (12, 45)),
			Range(Time (12, 50), Time (1, 30)),
			Range(Time (1, 35), Time (2, 15)), 
			Range(Time (2, 20), Time (3, 00)),
			Range(Time (3, 00), Time (3, 20)), 
			Range(Time (3, 20), Time (4, 00)),
			Range(Time (4, 05), Time (4, 45))
		],
		homeroom: 3,
		mincha: 10
	);

	static const Special rotate = Special (
		"A, B, or C day",
		[
			Range(Time (8, 00), Time (8, 45)), 
			Range(Time (8, 50), Time (9, 30)),
			Range(Time (9, 35), Time (10, 15)),
			Range(Time (10, 15), Time (10, 35)),
			Range(Time (10, 35), Time (11, 15)),
			Range(Time (11, 20), Time (12, 00)),
			Range(Time (12, 05), Time (12, 45)),
			Range(Time (12, 50), Time (1, 30)),
			Range(Time (1, 35), Time (2, 15)),
			Range(Time (2, 20), Time (3, 00)),
			Range(Time (3, 00), Time (3, 20)),
			Range(Time (3, 20), Time (4, 00)),
			Range(Time (4, 05), Time (4, 45))
		],
		homeroom: 3,
		mincha: 10
	);

	static const Special early = Special (
		"Early Dismissal",
		[
			Range(Time (8, 00), Time (8, 45)),
			Range(Time (8, 50), Time (9, 25)), 
			Range(Time (9, 30), Time (10, 05)),
			Range(Time (10, 05), Time (10, 20)),
			Range(Time (10, 20), Time (10, 55)),
			Range(Time (11, 00), Time (11, 35)),
			Range(Time (11, 40), Time (12, 15)),
			Range(Time (12, 20), Time (12, 55)),
			Range(Time (1, 00), Time (1, 35)), 
			Range(Time (1, 40), Time (2, 15)),
			Range(Time (2, 15), Time (2, 35)),
			Range(Time (2, 35), Time (3, 10)),
			Range(Time (3, 15), Time (3, 50))
		],
		homeroom: 3,
		mincha: 10
	);
}

@immutable
class Day {
	static List<Day> getCalendar(Map<String, dynamic> json) {
		final List<Day> result = List.filled(31, null, growable: true);
		for (final MapEntry<String, dynamic> entry in json.entries) {
			result [int.parse(entry.key) - 1] = 
				Day.fromJson(Map<String, dynamic>.from(entry.value));
		}
		result.removeWhere(
			(Day day) => day == null
		);
		return result;
	}

	final Letter letter;
	final Special special;

	const Day(this.letter, this.special);

	Day.fromJson(Map<String, dynamic> json) :
		letter = stringToLetter [json ["letter"]],
		special = json ["special"] == null 
			? null : json ["special"] is String 
				? Special.stringToSpecial [json ["special"]]
				: Special.fromJson(Map<String, dynamic>.from(json ["special"]));

	Map<String, dynamic> toJson() => {
		"letter": letterToString [letter],
		"special": special == null ? null : 
			Special.stringToSpecial.containsKey(special.name)
				? special.name
				: special.toJson()
	};
}
