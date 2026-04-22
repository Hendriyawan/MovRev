// ignore_for_file: strict_top_level_inference, prefer_typing_uninitialized_variables

class ApiException {

  final _message;
  ApiException([this._message]);

  @override
  String toString() {
    return "$_message";
  }

}


///Handle exception during communication
class FetchDataException extends ApiException {
  FetchDataException([String? super.message]);
}

//Handle exception bad request
class BadRequestException extends ApiException {
  BadRequestException([String? super.message]);
}

///Handle exception Unauthorized
class UnauthorizedException extends ApiException {
  UnauthorizedException([String? super.message]);
}

///Handle Exception input
class InvalidInputException extends ApiException {
  InvalidInputException([String? super.message]);
}

///Handle Exception server
class ErrorException extends ApiException {
  ErrorException([String? super.message]);
}