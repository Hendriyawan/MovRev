import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/entities/genre.dart';

enum GroupMode { week, month }

class MovieGroupingUtils {
  /// ISO 8601 week number (1–53).
  static int isoWeekNumber(DateTime dt) {
    final dayOfYear = int.parse(
      '${dt.difference(DateTime(dt.year, 1, 1)).inDays + 1}',
    );
    final wday = dt.weekday; // 1=Mon … 7=Sun
    return ((dayOfYear - wday + 10) / 7).floor();
  }

  /// The year that "owns" this ISO week (can differ for early Jan / late Dec).
  static int isoWeekYear(DateTime dt) {
    final week = isoWeekNumber(dt);
    if (week == 53 && dt.month == 1) return dt.year - 1;
    if (week == 1 && dt.month == 12) return dt.year + 1;
    return dt.year;
  }

  /// Returns the Monday of ISO week [week] in [year].
  static DateTime mondayOfIsoWeek(int year, int week) {
    // Jan 4 is always in ISO week 1
    final jan4 = DateTime(year, 1, 4);
    final monday1 = jan4.subtract(Duration(days: jan4.weekday - 1));
    return monday1.add(Duration(days: (week - 1) * 7));
  }

  /// Full month name (1-indexed).
  static String fullMonth(int m) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[(m - 1).clamp(0, 11)];
  }

  /// Returns a sortable group key for a movie based on [mode].
  static String groupKey(Movie movie, GroupMode mode) {
    final raw = movie.releaseDate;
    if (raw == null || raw.isEmpty) return 'Unknown';

    try {
      final dt = DateTime.parse(raw);
      if (mode == GroupMode.month) {
        return '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
      } else {
        final week = isoWeekNumber(dt);
        final weekYear = isoWeekYear(dt);
        return '$weekYear-W${week.toString().padLeft(2, '0')}';
      }
    } catch (_) {
      return 'Unknown';
    }
  }

  /// readable label for a group key.
  static String groupLabel(String key, GroupMode mode) {
    if (key == 'Unknown') return 'Unknown Date';

    try {
      if (mode == GroupMode.month) {
        final parts = key.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        return '${fullMonth(month)} $year';
      } else {
        final parts = key.split('-W');
        final year = int.parse(parts[0]);
        final week = int.parse(parts[1]);
        final monday = mondayOfIsoWeek(year, week);
        final sunday = monday.add(const Duration(days: 6));

        if (monday.month == sunday.month) {
          return '${monday.day}–${sunday.day} ${fullMonth(sunday.month)} ${sunday.year}';
        } else {
          return '${monday.day} ${fullMonth(monday.month)} – ${sunday.day} ${fullMonth(sunday.month)} ${sunday.year}';
        }
      }
    } catch (_) {
      return key;
    }
  }

  /// Returns true if the group represented by [key] has not fully elapsed yet.
  static bool isGroupInFuture(String key, DateTime now) {
    try {
      if (key.contains('-W')) {
        final parts = key.split('-W');
        final year = int.parse(parts[0]);
        final week = int.parse(parts[1]);
        final monday = mondayOfIsoWeek(year, week);
        final sunday = monday.add(const Duration(days: 6));
        return sunday.isAfter(now.subtract(const Duration(days: 1)));
      } else {
        final parts = key.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final lastDay = DateTime(year, month + 1, 0);
        return lastDay.isAfter(now.subtract(const Duration(days: 1)));
      }
    } catch (_) {
      return false;
    }
  }

  /// Groups movies and sorts them (nearest upcoming first).
  static List<MapEntry<String, List<Movie>>> groupMovies(
    List<Movie> movies,
    GroupMode mode,
  ) {
    final map = <String, List<Movie>>{};
    for (final movie in movies) {
      final key = groupKey(movie, mode);
      map.putIfAbsent(key, () => []).add(movie);
    }

    final now = DateTime.now();

    final entries = map.entries.toList()
      ..sort((a, b) {
        if (a.key == 'Unknown') return 1;
        if (b.key == 'Unknown') return -1;

        final aFuture = isGroupInFuture(a.key, now);
        final bFuture = isGroupInFuture(b.key, now);

        if (aFuture && !bFuture) return -1;
        if (!aFuture && bFuture) return 1;

        return a.key.compareTo(b.key);
      });

    return entries;
  }

  /// Groups movies by their most frequent genres.
  /// Output: ["Action", List<Movie>, "Adventure", List<Movie>, ...]
  static List<Map<String, dynamic>> groupByPopularGenre(
    List<Movie> movies,
    List<Genre> genres,
  ) {
    // 1. Accumulate total popularity score per genre
    final genrePopScores = <int, double>{};
    for (final movie in movies) {
      if (movie.genreIds != null) {
        for (final id in movie.genreIds!) {
          genrePopScores[id] =
              (genrePopScores[id] ?? 0.0) + (movie.popularity ?? 0.0);
        }
      }
    }

    // 2. Sort genres by Total Popularity Score descending
    final sortedGenres =
        genres.where((g) => g.id != null && g.name != null).toList()
          ..sort((a, b) {
            final scoreA = genrePopScores[a.id] ?? 0.0;
            final scoreB = genrePopScores[b.id] ?? 0.0;
            return scoreB.compareTo(scoreA);
          });

    // 3. Build output: List of Maps for better accessibility
    final result = <Map<String, dynamic>>[];
    for (final genre in sortedGenres) {
      final score = genrePopScores[genre.id] ?? 0.0;
      if (score > 0) {
        final genreMovies = movies
            .where((m) => m.genreIds?.contains(genre.id) ?? false)
            .toList();

        if (genreMovies.isNotEmpty) {
          result.add({
            'id': genre.id,
            'name': genre.name!,
            'movies': genreMovies,
            'score': score.truncate(),
          });
        }
      }
    }

    return result;
  }
}
