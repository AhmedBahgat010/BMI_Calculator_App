import 'package:bim_app_task/core/core.dart';
import 'package:bim_app_task/dependencies_injection.dart';
import 'package:bim_app_task/features/auth/auth.dart';
import 'package:bim_app_task/features/home/domain/domain.dart';
import 'package:bim_app_task/features/home/presentation/cubit/bmi_cubit.dart';
import 'package:bim_app_task/features/home/presentation/page/BMIScreen.dart';
import 'package:bim_app_task/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:share_plus/share_plus.dart';

import '../page/home_page.dart';

class ScoreScreen extends StatelessWidget {
  final double bmiScore;

  final int age;
  final int height;
  final int weight;

  String? bmiStatus;

  String? bmiInterpretation;

  Color? bmiStatusColor;

  ScoreScreen(
      {Key? key,
      required this.bmiScore,
      required this.age,
      required this.height,
      required this.weight})
      : super(key: key);
  String UID = CacheHelper.getData(
    key: "uId",
  );

  @override
  Widget build(BuildContext context) {
    setBmiInterpretation();
    return BlocListener<BMICubit, BMIState>(
      listener: (_, state) {
        if (state is BMIStateLoading) {
          context.show();
        } else if (state is BMIStateSuccess) {
          context.dismiss();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text("Your BMI saved successfully"),
            duration: const Duration(seconds: 2),
          ));
        } else if (state is BMIStateFailed) {
          context.dismiss();
          state.error.toString().toToastError(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("BMI Score"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    // Provide the BMICubit instance to the BMIScreen
                    return BlocProvider.value(
                      value: sl<BMICubit>()..fetchBMIList(),
                      child: BMIScreen(),
                    );
                  }));
                },
                child: CardIcon(
                  icon: Icons.save,
                ),
              ),
            )
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(12),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Your Score",
                style: TextStyle(fontSize: 30, color: Colors.blue),
              ),
              const SizedBox(
                height: 10,
              ),
              PrettyGauge(
                gaugeSize: 300,
                minValue: 0,
                showMarkers: true,
                maxValue: 40,
                segments: [
                  GaugeSegment('UnderWeight', 18.5, Colors.red),
                  GaugeSegment('Normal', 6.4, Colors.green),
                  GaugeSegment('OverWeight', 5, Colors.orange),
                  GaugeSegment('Obese', 10.1, Colors.pink),
                ],
                valueWidget: Text(
                  "BMI =${bmiScore.toStringAsFixed(1)}",
                  style: const TextStyle(fontSize: 30),
                ),
                currentValue: bmiScore.toDouble(),
                needleColor: Colors.blue,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                bmiStatus!,
                style: TextStyle(fontSize: 20, color: bmiStatusColor!),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                bmiInterpretation!,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Share.share(
                            "Your BMI is ${bmiScore.toStringAsFixed(1)} at age $age");
                      },
                      child: const Text("Share")),
                  ElevatedButton(
                      onPressed: () {
                        DateTime timestamp = DateTime.now();
                        context.read<BMICubit>().saveBMI(SaveBMIParams(
                            weight: weight,
                            height: height,
                            age: age,
                            time: timestamp,
                            id: UID));
                      },
                      child: const Text("Save")),
                ],
              )
            ])),
      ),
    );
  }

  void setBmiInterpretation() {
    if (bmiScore > 30) {
      bmiStatus = "Obese";
      bmiInterpretation = "Please work to reduce obesity";
      bmiStatusColor = Colors.pink;
    } else if (bmiScore >= 25) {
      bmiStatus = "Overweight";
      bmiInterpretation = "Do regular exercise & reduce the weight";
      bmiStatusColor = Colors.orange;
    } else if (bmiScore >= 18.5) {
      bmiStatus = "Normal";
      bmiInterpretation = "Enjoy, You are fit";
      bmiStatusColor = Colors.green;
    } else if (bmiScore < 18.5) {
      bmiStatus = "Underweight";
      bmiInterpretation = "Try to increase the weight";
      bmiStatusColor = Colors.red;
    }
  }
}
