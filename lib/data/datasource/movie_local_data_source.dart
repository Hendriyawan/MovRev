import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:movrev/data/models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<void> insertFavorite(MovieModel movie);
  Future<void> removeFavorite(int id);
  Future<List<MovieModel>> getFavorites();
  Future<bool> isFavorite(int id);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'movie_favorites.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            title TEXT,
            poster_path TEXT,
            backdrop_path TEXT,
            vote_average REAL,
            overview TEXT,
            release_date TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<void> insertFavorite(MovieModel movie) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'id': movie.id,
        'title': movie.title,
        'poster_path': movie.posterPath,
        'backdrop_path': movie.backdropPath,
        'vote_average': movie.voteAverage,
        'overview': movie.overview,
        'release_date': movie.releaseDate,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<MovieModel>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return maps.map((map) {
      return MovieModel(
        id: map['id'],
        title: map['title'],
        posterPath: map['poster_path'],
        backdropPath: map['backdrop_path'],
        voteAverage: map['vote_average'],
        overview: map['overview'],
        releaseDate: map['release_date'],
      );
    }).toList();
  }

  @override
  Future<bool> isFavorite(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}
