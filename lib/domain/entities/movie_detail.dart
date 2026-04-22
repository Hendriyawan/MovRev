import 'genre.dart';

class MovieDetail {
  final bool? adult;
  final String? backdropPath;
  final BelongsToCollection? belongsToCollection;
  final int? budget;
  final List<Genre>? genres;
  final String? homepage;
  final int? id;
  final String? imdbId;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final List<ProductionCompany>? productionCompanies;
  final List<ProductionCountry>? productionCountries;
  final String? releaseDate;
  final int? revenue;
  final int? runtime;
  final List<SpokenLanguage>? spokenLanguages;
  final String? status;
  final String? tagline;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  const MovieDetail({
    this.adult,
    this.backdropPath,
    this.belongsToCollection,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdbId,
    this.originCountry,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });
}

class BelongsToCollection {
  final int? id;
  final String? name;
  final String? posterPath;
  final String? backdropPath;

  const BelongsToCollection({
    this.id,
    this.name,
    this.posterPath,
    this.backdropPath,
  });
}

class ProductionCompany {
  final int? id;
  final String? logoPath;
  final String? name;
  final String? originCountry;

  const ProductionCompany({
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });
}

class ProductionCountry {
  final String? iso31661;
  final String? name;

  const ProductionCountry({
    this.iso31661,
    this.name,
  });
}

class SpokenLanguage {
  final String? englishName;
  final String? iso6391;
  final String? name;

  const SpokenLanguage({
    this.englishName,
    this.iso6391,
    this.name,
  });
}
