import 'package:bim_app_task/features/home/domain/domain.dart';
import 'package:bim_app_task/features/home/domain/repositories/BMI_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';

class GetBMIList extends UseCase<List<BMI>, NoParams> {
  final BMIRepository repository;

  GetBMIList(this.repository);

  @override
  Future<Either<Failure, List<BMI>>> call(NoParams params) async {
    return await repository.getBMIList();
  }
}
