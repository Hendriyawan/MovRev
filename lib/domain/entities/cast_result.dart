import 'cast.dart';

class CastResult {
  final int? id;
  final List<Cast>? cast;
  final String? errorMessage;

  const CastResult({
    this.id,
    this.cast,
    this.errorMessage,
  });
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
