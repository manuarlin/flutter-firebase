import 'package:flutter/material.dart';
import 'package:flutter_firebase/results.dart';
import 'package:flutter_firebase/vote.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Night Clazz Votes',
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int currentStep = 0;
  bool isNextStepActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Night Clazz Votes')),
        body: Container(
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            steps: <Step>[
              Step(
                  title: Text("Vote"),
                  content: Vote(_voteCallback),
                  isActive: true),
              Step(
                  title: Text("Résultats"),
                  content: Results(),
                  isActive: isNextStepActive)
            ],
            controlsBuilder: _buildControls,
            onStepContinue: () {
              if (isNextStepActive && currentStep < 1) {
                setState(() {
                  currentStep += 1;
                });
              }
            },
            onStepCancel: () {
              setState(() {
                currentStep = 0;
                isNextStepActive = false;
              });
            },
          ),
        ));
  }

  Widget _buildControls(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    final buttons = <Widget>[];
    if (currentStep == 0) {
      buttons.add(MaterialButton(
        child: Text("Continuer"),
        color: isNextStepActive ? Colors.red : Colors.grey,
        onPressed: onStepContinue,
      ));
    } else {
      buttons.add(MaterialButton(
        child: Text("Retour"),
        color: Colors.red[100],
        onPressed: onStepCancel,
      ));
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ButtonBar(children: buttons)]);
  }

  _voteCallback() {
    setState(() {
      isNextStepActive = true;
    });
  }
}
