part of 'bmi_cubit.dart';

abstract class BMIState extends Equatable {
  final List<BMI>? bmiList;
  final String? error;

  const BMIState({
    this.bmiList,
    this.error,
  });

  @override
  List<Object?> get props => [error, bmiList];
}

class BMIStateInit extends BMIState {
  const BMIStateInit();
}

class BMIStateLoading extends BMIState {
  const BMIStateLoading();
}

class BMIStateSuccess extends BMIState {
  const BMIStateSuccess();
}

class BMIStateFailed extends BMIState {
  const BMIStateFailed({super.error});
}

class GetBMIStateLoading extends BMIState {
  const GetBMIStateLoading();
}

class GetBMIStateSuccess extends BMIState {
  const GetBMIStateSuccess({super.bmiList});
}

class GetBMIStateFailed extends BMIState {
  const GetBMIStateFailed({super.error});
}

class EditBMIStateLoading extends BMIState {
  const EditBMIStateLoading();
}

class EditBMIStateSuccess extends BMIState {
  const EditBMIStateSuccess();
}

class EditBMIStateFailed extends BMIState {
  const EditBMIStateFailed({super.error});
}
