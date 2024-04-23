import 'dart:math';

import 'package:bim_app_task/features/auth/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import 'package:flutter/material.dart';

import '../../../../core/resources/palette.dart';
import 'package:page_transition/page_transition.dart';

import '../widget/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tabIndex = 0;

  int _gender = 0;
  int _height = 150;
  int _age = 30;
  int _weight = 50;
  bool _isFinished = false;
  double _bmiScore = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Returning false will prevent the user from going back to the previous screen
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
                //leading: const SizedBox(),
                centerTitle: true,
                title: ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: const CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(
                          "https://www.powertrafic.fr/wp-content/uploads/2023/04/image-ia-exemple.png"),
                    ),
                    title: const Text("Welcome 👋"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => LoginPage()),
                                (route) => false);
                          },
                          child: const CardIcon(
                            icon: Icons.output,
                          ),
                        ),
                      ],
                    ))),
            body: SingleChildScrollView(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Card(
                  color: Palette.white,
                  surfaceTintColor: Palette.white,
                  shadowColor: Palette.white,
                  elevation: 12,
                  child: Column(
                    children: [
                      //Lets create widget for gender selection

                      HeightWidget(
                        onChange: (heightVal) {
                          _height = heightVal;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AgeWeightWidget(
                              onChange: (ageVal) {
                                _age = ageVal;
                              },
                              title: "Age",
                              initValue: 30,
                              min: 1,
                              max: 100),
                          AgeWeightWidget(
                              onChange: (weightVal) {
                                _weight = weightVal;
                              },
                              title: "Weight",
                              initValue: 50,
                              min: 1,
                              max: 100),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 60),
                        child: SwipeableButtonView(
                            isFinished: _isFinished,
                            onFinish: () async {
                              await Navigator.push(
                                  context,
                                  PageTransition(
                                      child: ScoreScreen(
                                        bmiScore: _bmiScore,
                                        age: _age,
                                        height: _height,
                                        weight: _weight,
                                      ),
                                      type: PageTransitionType.fade));

                              setState(() {
                                _isFinished = false;
                              });
                            },
                            onWaitingProcess: () {
                              //Calculate BMI here
                              calculateBmi();

                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  _isFinished = true;
                                });
                              });
                            },
                            activeColor: Palette.primary,
                            buttonWidget: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                            ),
                            buttonText: "CALCULATE"),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }
}

class CardIcon extends StatelessWidget {
  final IconData icon;
  const CardIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Palette.primaryWithOpacity,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(
          icon,
          color: Palette.primary,
        ),
      ),
    );
  }
}
