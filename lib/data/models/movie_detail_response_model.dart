import '../../domain/entities/movie_detail.dart';
import 'genre_model.dart';

class MovieDetailResponseModel extends MovieDetail {
  const MovieDetailResponseModel({
    super.adult,
    super.backdropPath,
    super.belongsToCollection,
    super.budget,
    super.genres,
    super.homepage,
    super.id,
    super.imdbId,
    super.originCountry,
    super.originalLanguage,
    super.originalTitle,
    super.overview,
    super.popularity,
    super.posterPath,
    super.productionCompanies,
    super.productionCountries,
    super.releaseDate,
    super.revenue,
    super.runtime,
    super.spokenLanguages,
    super.status,
    super.tagline,
    super.title,
    super.video,
    super.voteAverage,
    super.voteCount,
  });

  factory MovieDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      MovieDetailResponseModel(
        adult: json['adult'] as bool?,
        backdropPath: json['backdrop_path'] as String?,
        belongsToCollection: json['belongs_to_collection'] != null
            ? BelongsToCollectionModel.fromJson(
                json['belongs_to_collection'] as Map<String, dynamic>)
            : null,
        budget: json['budget'] as int?,
        genres: (json['genres'] as List<dynamic>?)
            ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        homepage: json['homepage'] as String?,
        id: json['id'] as int?,
        imdbId: json['imdb_id'] as String?,
        originCountry: (json['origin_country'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        originalLanguage: json['original_language'] as String?,
        originalTitle: json['original_title'] as String?,
        overview: json['overview'] as String?,
        popularity: (json['popularity'] as num?)?.toDouble(),
        posterPath: json['poster_path'] as String?,
        productionCompanies: (json['production_companies'] as List<dynamic>?)
            ?.map((e) => ProductionCompanyModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        productionCountries: (json['production_countries'] as List<dynamic>?)
            ?.map((e) => ProductionCountryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        releaseDate: json['release_date'] as String?,
        revenue: json['revenue'] as int?,
        runtime: json['runtime'] as int?,
        spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
            ?.map((e) => SpokenLanguageModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        status: json['status'] as String?,
        tagline: json['tagline'] as String?,
        title: json['title'] as String?,
        video: json['video'] as bool?,
        voteAverage: (json['vote_average'] as num?)?.toDouble(),
        voteCount: json['vote_count'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'backdrop_path': backdropPath,
        'belongs_to_collection': belongsToCollection != null
            ? BelongsToCollectionModel.fromEntity(belongsToCollection!).toJson()
            : null,
        'budget': budget,
        'genres': genres?.map((e) => GenreModel.fromEntity(e).toJson()).toList(),
        'homepage': homepage,
        'id': id,
        'imdb_id': imdbId,
        'origin_country': originCountry,
        'original_language': originalLanguage,
        'original_title': originalTitle,
        'overview': overview,
        'popularity': popularity,
        'poster_path': posterPath,
        'production_companies': productionCompanies
            ?.map((e) => ProductionCompanyModel.fromEntity(e).toJson())
            .toList(),
        'production_countries': productionCountries
            ?.map((e) => ProductionCountryModel.fromEntity(e).toJson())
            .toList(),
        'release_date': releaseDate,
        'revenue': revenue,
        'runtime': runtime,
        'spoken_languages': spokenLanguages
            ?.map((e) => SpokenLanguageModel.fromEntity(e).toJson())
            .toList(),
        'status': status,
        'tagline': tagline,
        'title': title,
        'video': video,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

}

class BelongsToCollectionModel extends BelongsToCollection {
  const BelongsToCollectionModel({
    super.id,
    super.name,
    super.posterPath,
    super.backdropPath,
  });

  factory BelongsToCollectionModel.fromJson(Map<String, dynamic> json) =>
      BelongsToCollectionModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
      );

  factory BelongsToCollectionModel.fromEntity(BelongsToCollection entity) =>
      BelongsToCollectionModel(
        id: entity.id,
        name: entity.name,
        posterPath: entity.posterPath,
        backdropPath: entity.backdropPath,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
      };
}

class ProductionCompanyModel extends ProductionCompany {
  const ProductionCompanyModel({
    super.id,
    super.logoPath,
    super.name,
    super.originCountry,
  });

  factory ProductionCompanyModel.fromJson(Map<String, dynamic> json) =>
      ProductionCompanyModel(
        id: json['id'] as int?,
        logoPath: json['logo_path'] as String?,
        name: json['name'] as String?,
        originCountry: json['origin_country'] as String?,
      );

  factory ProductionCompanyModel.fromEntity(ProductionCompany entity) =>
      ProductionCompanyModel(
        id: entity.id,
        logoPath: entity.logoPath,
        name: entity.name,
        originCountry: entity.originCountry,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'logo_path': logoPath,
        'name': name,
        'origin_country': originCountry,
      };
}

class ProductionCountryModel extends ProductionCountry {
  const ProductionCountryModel({
    super.iso31661,
    super.name,
  });

  factory ProductionCountryModel.fromJson(Map<String, dynamic> json) =>
      ProductionCountryModel(
        iso31661: json['iso_3166_1'] as String?,
        name: json['name'] as String?,
      );

  factory ProductionCountryModel.fromEntity(ProductionCountry entity) =>
      ProductionCountryModel(
        iso31661: entity.iso31661,
        name: entity.name,
      );

  Map<String, dynamic> toJson() => {
        'iso_3166_1': iso31661,
        'name': name,
      };
}

class SpokenLanguageModel extends SpokenLanguage {
  const SpokenLanguageModel({
    super.englishName,
    super.iso6391,
    super.name,
  });

  factory SpokenLanguageModel.fromJson(Map<String, dynamic> json) =>
      SpokenLanguageModel(
        englishName: json['english_name'] as String?,
        iso6391: json['iso_639_1'] as String?,
        name: json['name'] as String?,
      );

  factory SpokenLanguageModel.fromEntity(SpokenLanguage entity) =>
      SpokenLanguageModel(
        englishName: entity.englishName,
        iso6391: entity.iso6391,
        name: entity.name,
      );

  Map<String, dynamic> toJson() => {
        'english_name': englishName,
        'iso_639_1': iso6391,
        'name': name,
      };
}
