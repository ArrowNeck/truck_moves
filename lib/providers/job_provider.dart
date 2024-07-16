import 'package:flutter/material.dart';
import 'package:truck_moves/models/job.dart';

class JobProvider with ChangeNotifier {
  JobProviderState currentJobState = JobProviderState.idle;
  JobProviderState futureJobState = JobProviderState.idle;

  List<Job>? currentJobs;
  List<Job>? futureJobs;

  Job? currentlyRunningJob;

  void setCurrentlyRunningJob(Job job) {
    currentlyRunningJob = job;
    notifyListeners();
  }

  void removeCurrentlyRunningJob() {
    currentlyRunningJob = null;
  }

  void setCurrentJobs(List<Job> jobs) {
    if (currentJobs == null) {
      currentJobs = jobs;
    } else {
      currentJobs?.addAll(jobs);
    }
    notifyListeners();
  }

  void setFutureJobs(List<Job> jobs) {
    if (futureJobs == null) {
      futureJobs = jobs;
    } else {
      futureJobs?.addAll(jobs);
    }
    notifyListeners();
  }

  // void addPrechecklist({required PreDepartureChecklist data}) {
  //   int index = currentJobs!.indexWhere((job) => job.id == data.jobId);
  //   currentJobs![index].preDepartureChecklist = data;
  //   currentJobs![index].status = 4;
  //   notifyListeners();
  // }

  void addPrechecklist({required PreDepartureChecklist data}) {
    currentlyRunningJob!.preDepartureChecklist = data;
    currentlyRunningJob!.status = 4;
    notifyListeners();
  }

  void jobClose({required int jobId}) {
    currentlyRunningJob = null;
    currentJobs!.removeWhere((job) => job.id == jobId);
    notifyListeners();
  }

  void addLeg({required Leg data}) {
    currentlyRunningJob!.legs.add(data);
    currentlyRunningJob!.status = 6;
    notifyListeners();
  }

  void updateLeg({required Leg data, required bool isCompleted}) {
    currentlyRunningJob!.legs[currentlyRunningJob!.legs
        .indexWhere((leg) => leg.id == data.id)] = data;
    currentlyRunningJob!.status = isCompleted ? 9 : 7;
    notifyListeners();
  }

  bool canAccessThisJob({required int jobId}) {
    // int? higherStatusJobId;
    // for (var job in currentJobs!) {
    //   if (job.status > 3) {
    //     higherStatusJobId = job.id;
    //   }
    // }
    // return (higherStatusJobId == null || higherStatusJobId == jobId);
    return true;
  }
}

enum JobProviderState { idle, loading, error, success }
