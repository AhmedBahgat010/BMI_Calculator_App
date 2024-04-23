import 'package:bim_app_task/features/home/domain/domain.dart';
import 'package:bim_app_task/features/home/domain/usecases/DeleteBMI.dart';
import 'package:bim_app_task/features/home/domain/usecases/editBMI.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
part 'bmi_state.dart';

class BMICubit extends Cubit<BMIState> {
  BMICubit(
    this._saveBMI,
    this._deleteBMI,
    this._getBMIList,
    this._editBMI,
  ) : super(const BMIStateInit());

  final SaveBMI _saveBMI;
  final DeleteBMI _deleteBMI;
  final EditBMI _editBMI;

  final GetBMIList _getBMIList;

  Future<void> saveBMI(SaveBMIParams params) async {
    try {
      emit(const BMIStateLoading());
      final data = await _saveBMI.call(params);

      data.fold(
        (l) {
          if (l is ServerFailure) {
            emit(BMIStateFailed(error: l.message.toString()));
          }
        },
        (r) => emit(BMIStateSuccess()),
      );
    } catch (e) {
      emit(BMIStateFailed(error: e.toString()));
    }
  }

  void fetchBMIList() async {
    emit(const GetBMIStateLoading());
    final bmiListEither = await _getBMIList(NoParams());
    bmiListEither.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(GetBMIStateFailed(error: failure.message.toString()));
        }
      },
      (bmiList) => emit(GetBMIStateSuccess(bmiList: bmiList)),
    );
  }

  Future<bool> deleteBMI(String bmiId) async {
    try {
      // Call the delete method from your BMIRemoteDatasource
      final result = await _deleteBMI(bmiId);
      return result.fold(
        (failure) {
          return false;
        },
        (bmiList) {
          return true;
        },
      );
    } catch (e) {
      // Handle errors
      print('Error deleting BMI data: $e');
      return false;
    }
  }

  Future<void> editBMI(EditBMIParams params) async {
    try {
      emit(const EditBMIStateLoading());
      final data = await _editBMI.call(params);

      data.fold(
        (l) {
          if (l is ServerFailure) {
            emit(EditBMIStateFailed(error: l.message.toString()));
          }
        },
        (r) => emit(const EditBMIStateSuccess()),
      );
    } catch (e) {
      emit(EditBMIStateFailed(error: e.toString()));
    }
  }
}
