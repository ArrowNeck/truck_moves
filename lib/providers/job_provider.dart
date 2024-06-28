import 'package:flutter/material.dart';
import 'package:truck_moves/models/job_header.dart';

class JobProvider with ChangeNotifier {
  JobProviderState currentJobState = JobProviderState.idle;
  JobProviderState futureJobState = JobProviderState.idle;

  List<JobHeader>? currentJobs;
  List<JobHeader>? futureJobs;

  void setCurrentJobs(List<JobHeader> jobs) {
    if (currentJobs == null) {
      currentJobs = jobs;
    } else {
      currentJobs?.addAll(jobs);
    }
    notifyListeners();
  }

  void setFutureJobs(List<JobHeader> jobs) {
    if (futureJobs == null) {
      futureJobs = jobs;
    } else {
      futureJobs?.addAll(jobs);
    }
    notifyListeners();
  }
}

enum JobProviderState { idle, loading, error, success }
