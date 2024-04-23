import 'dart:developer';

import 'package:bim_app_task/core/core.dart';
import 'package:bim_app_task/features/home/domain/usecases/editBMI.dart';
import 'package:bim_app_task/features/home/presentation/widget/age_weight_widget.dart';
import 'package:bim_app_task/features/home/presentation/widget/height_widget.dart';
import 'package:bim_app_task/utils/ext/context.dart';
import 'package:bim_app_task/utils/ext/ext.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubit/bmi_cubit.dart'; // Import flutter_bloc package

String UID = CacheHelper.getData(
  key: "uId",
);

class BMIScreen extends StatelessWidget {
  @override
  int _height = 150;
  int _age = 30;
  int _weight = 50;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Data'),
      ),
      body: BlocConsumer<BMICubit, BMIState>(
        listener: (_, state) {
          log(state.toString());
          if (state is EditBMIStateLoading) {
            context.show();
          } else if (state is EditBMIStateSuccess) {
            context.dismiss();
            context.dismiss();
            context
                .read<BMICubit>()
                .fetchBMIList(); // Trigger BMI data fetching

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Your BMI Edit successfully"),
              duration: Duration(seconds: 2),
            ));
          } else if (state is EditBMIStateFailed) {
            context.dismiss();
            state.error.toString().toToastError(context);
          }
        },
        builder: (context, state) {
          log(state.toString());
          if (state is GetBMIStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetBMIStateFailed) {
            return Center(
              child: Text(state.error.toString()),
            );
          } else if (state is GetBMIStateSuccess) {
            final bmiList = state
                .bmiList; // Assuming BMIStateSuccess holds a List<BMIModel>

            return ListView.builder(
              itemCount: bmiList?.length ?? 0,
              itemBuilder: (context, index) {
                final bmi = bmiList![index];
                return ListTile(
                    title: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                        'Weight: ${bmi.weight}, Height: ${bmi.height}, Age: ${bmi.age}, Time: ${DateFormat.yMd().add_jm().format(bmi.timestamp)}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showBottomSheet(
                              context: context,
                              height: bmi.height,
                              age: bmi.age,
                              weight: bmi.weight,
                              id: bmi.id!,
                              onPressed: () {
                                DateTime timestamp = DateTime.now();
                                context.read<BMICubit>().editBMI(EditBMIParams(
                                      height: _height,
                                      age: _age,
                                      weight: _weight,
                                      id: bmi.id!,
                                      time: timestamp,
                                      Uid: UID,
                                    ));
                              },
                            );
                          }),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            final result = await context
                                .read<BMICubit>()
                                .deleteBMI(bmi.id!);
                            if (result) {
                              context.read<BMICubit>().fetchBMIList();
                              // Update UI or show a success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content:
                                      Text('BMI data deleted successfully'),
                                ),
                              );
                            } else {
                              // Handle deletion failure
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Palette.red,
                                  content: Text('Failed to delete BMI data'),
                                ),
                              );
                            }
                          })
                    ]));
              },
            );
          } else {
            return Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<BMICubit>().fetchBMIList(); // Trigger BMI data fetching
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _showBottomSheet(
      {required BuildContext context,
      required int height,
      required int age,
      required int weight,
      required String id,
      required Function onPressed}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              //Lets create widget for gender selection

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: HeightWidget(
                  onChange: (heightVal) {
                    _height = heightVal;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AgeWeightWidget(
                      onChange: (ageVal) {
                        _age = ageVal;
                      },
                      title: "Age",
                      initValue: age,
                      min: 1,
                      max: 100),
                  AgeWeightWidget(
                      onChange: (weightVal) {
                        _weight = weightVal;
                      },
                      title: "Weight",
                      initValue: weight,
                      min: 1,
                      max: 100),
                ],
              ),
              SizedBox(
                width: 200,
                child: Button(
                  key: const Key("btn_register"),
                  title: "Edit",
                  onPressed: () {
                    onPressed();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
