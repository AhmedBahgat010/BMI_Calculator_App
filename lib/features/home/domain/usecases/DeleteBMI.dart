import 'package:bim_app_task/core/core.dart';
import 'package:bim_app_task/features/home/data/data.dart';
import 'package:dartz/dartz.dart';

class DeleteBMI extends UseCase<bool, String> {
  final BMIRemoteDatasource repository;

  DeleteBMI(this.repository);

  @override
  Future<Either<Failure, bool>> call(String bmiId) async {
    try {
      final result = await repository.deleteBMI(bmiId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure("Failed to delete BMI data"));
    }
  }
}
