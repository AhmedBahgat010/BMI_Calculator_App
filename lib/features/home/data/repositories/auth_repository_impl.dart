import 'package:bim_app_task/core/core.dart';
import 'package:bim_app_task/features/home/data/data.dart';
import 'package:bim_app_task/features/home/domain/domain.dart';
import 'package:bim_app_task/features/home/domain/repositories/BMI_repository.dart';
import 'package:bim_app_task/features/home/domain/usecases/editBMI.dart';
import 'package:bim_app_task/utils/services/hive/hive.dart';
import 'package:dartz/dartz.dart';

class BMIRepositoryImpl implements BMIRepository {
  final BMIRemoteDatasource bmiRemoteDatasource;
  final MainBoxMixin mainBoxMixin;

  const BMIRepositoryImpl(this.bmiRemoteDatasource, this.mainBoxMixin);

  @override
  Future<Either<Failure, BMIModel>> saveBMI(SaveBMIParams saveBMIParams) async {
    final response = await bmiRemoteDatasource.saveBMI(saveBMIParams);

    return response.fold(
      (failure) => Left(failure),
      (bmiModel) => Right(bmiModel),
    );
  }

  Future<Either<Failure, List<BMIModel>>> getBMIList() async {
    return await bmiRemoteDatasource.getBMIList();
  }

  @override
  Future<bool> deleteBMI(String bmiId) async {
    final result = await bmiRemoteDatasource.deleteBMI(bmiId);
    return result;
  }

  @override
  Future<Either<Failure, BMI>> editBMI(EditBMIParams editBMIParams) async {
    final result = await bmiRemoteDatasource.editBMI(editBMIParams);
    return result.fold(
      (failure) => Left(failure),
      (bmiModel) => Right(bmiModel),
    );
  }
}
