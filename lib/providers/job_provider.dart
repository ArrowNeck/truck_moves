import 'package:flutter/material.dart';
import 'package:truck_moves/models/job.dart';

class JobProvider with ChangeNotifier {
  List<Job> currentJobs = [];
  List<Job> futureJobs = [];
  List<Job> storeJobs = [];

  Job? currentlyRunningJob;
  int? previousStatus;

  void setCurrentlyRunningJob(Job job) {
    currentlyRunningJob = job;
    notifyListeners();
  }

  void removeCurrentlyRunningJob() {
    currentlyRunningJob = null;
  }

  void setPreviousStatus(int status) {
    previousStatus = status;
  }

  void setCurrentJobs(List<Job> jobs) {
    currentJobs.addAll(jobs);
    notifyListeners();
  }

  void setFutureJobs(List<Job> jobs) {
    futureJobs.addAll(jobs);
    notifyListeners();
  }

  void setStoreJobs(List<Job> jobs) {
    storeJobs.addAll(jobs);
    notifyListeners();
  }

  void breakdownStatus(bool occurred, {String? endLocation}) {
    if (endLocation != null) {
      currentlyRunningJob!.legs.last.endLocation = endLocation;
    }
    currentlyRunningJob!.status = occurred ? 8 : 7;
    notifyListeners();
  }

  void addPrechecklist({required PreDepartureChecklist data}) {
    currentlyRunningJob!.preDepartureChecklist = data;
    currentlyRunningJob!.status = 4;
    notifyListeners();
  }

  void addLeg({required Leg data}) {
    currentlyRunningJob!.legs.add(data);
    currentlyRunningJob!.status = 6;
    notifyListeners();
  }

  void updateLeg({required String endLocation, required int jobStatus}) {
    currentlyRunningJob!.legs.last.endLocation = endLocation;
    currentlyRunningJob!.status = jobStatus; //7|9|15
    notifyListeners();
  }

  void updateTrailerStatus({required int id, required bool isHookup}) {
    currentlyRunningJob!.trailers.firstWhere((e) => e.id == id).status =
        isHookup ? 1 : 2;
    notifyListeners();
  }

  bool canAccessThisJob({required int jobId}) {
    int? higherStatusJobId;
    for (var job in currentJobs) {
      if (job.status > 3) {
        higherStatusJobId = job.id;
      }
    }
    return (higherStatusJobId == null || higherStatusJobId == jobId);
    // return true;
  }
}
