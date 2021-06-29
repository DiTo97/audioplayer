// Custom imports
import 'package:companion/exceptions/exception_base.dart';


class FetchDataException extends BaseException {
  FetchDataException([String? message]):
        super(message, 'Communication error: ');
}

class BadRequestException extends BaseException {
  BadRequestException([message]):
        super(message, 'Invalid request: ');
}

class UnauthorisedException extends BaseException {
  UnauthorisedException([message]):
        super(message, 'Unauthorised request: ');
}

class InvalidInputException extends BaseException {
  InvalidInputException([String? message]):
        super(message, 'Invalid input: ');
}