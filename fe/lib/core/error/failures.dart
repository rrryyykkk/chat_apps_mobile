/// [Failure] adalah kelas dasar untuk menangani error di aplikasi.
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = "Server Error occurred"]);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = "Cache Error occurred"]);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = "Please check your internet connection"]);
}
