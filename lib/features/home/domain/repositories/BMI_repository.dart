import 'package:bim_app_task/features/home/data/models/BMIModel.dart';
import 'package:bim_app_task/features/home/domain/domain.dart';
import 'package:bim_app_task/features/home/domain/usecases/editBMI.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class BMIRepository {
  Future<Either<Failure, BMI>> saveBMI(SaveBMIParams SaveBMIParams);
  Future<Either<Failure, List<BMIModel>>> getBMIList();
  Future<Either<Failure, BMI>> editBMI(EditBMIParams editBMIParams);
}
