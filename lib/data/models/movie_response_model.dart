import 'movie_model.dart';

class MovieResponseModel {
  final Map<String, dynamic>? dates;
  final int? page;
  final List<MovieModel>? results;
  final int? totalPages;
  final int? totalResults;

  const MovieResponseModel({
    this.dates,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) {
    return MovieResponseModel(
      dates: json['dates'] as Map<String, dynamic>?,
      page: json['page'] as int?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int?,
      totalResults: json['total_results'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() => {
        'dates': dates,
        'page': page,
        'results': results?.map((e) => e.toJson()).toList(),
        'total_pages': totalPages,
        'total_results': totalResults,
      };
}
