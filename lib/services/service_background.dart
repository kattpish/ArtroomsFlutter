
// import 'package:background_fetch/background_fetch.dart';
//
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   var taskId = task.taskId;
//   if (task.timeout) {
//     BackgroundFetch.finish(taskId);
//     return;
//   }
//
//   BackgroundFetch.finish(taskId);
// }

void configure() {

  // // Configure Background Fetch
  // BackgroundFetch.configure(BackgroundFetchConfig(
  //     minimumFetchInterval: 15,
  //     stopOnTerminate: false,
  //     startOnBoot: true,
  //     enableHeadless: true
  // ), (String taskId) {
  //   // This is the fetch-event callback.
  // }).then((int status) {
  //   print('[BackgroundFetch] configure success: $status');
  // }).catchError((e) {
  //   print('[BackgroundFetch] configure ERROR: $e');
  // });
  //
  // // Register headless task
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  //
}