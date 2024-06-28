import 'package:flutter/material.dart';
import 'package:truck_moves/models/job_header.dart';
import 'package:truck_moves/shared_widgets/app_bar.dart';

class Acknowledgement extends StatefulWidget {
  final JobHeader job;
  const Acknowledgement({super.key, required this.job});

  @override
  State<Acknowledgement> createState() => _AcknowledgementState();
}

class _AcknowledgementState extends State<Acknowledgement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(label: "Acknowledgement"),
      body: const SafeArea(
          child: Column(
        children: [],
      )),
    );
  }
}
