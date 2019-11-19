import 'package:sembast/sembast.dart';
import 'package:trainer_app_flutter/models/workout.dart';
import '../data/app_database.dart';

class WorkoutDao {
  static const String WORKOUTS_STORE_NAME = 'workouts';

  final _workoutsStore = stringMapStoreFactory.store(WORKOUTS_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<List<Workout>> insert(Workout workout) async {
    var response = await _workoutsStore.record(workout.sId).put(await _db, workout.toJson());
    Workout newEntry = Workout.fromJson(response);

    return <Workout>[newEntry];
  }

  Future update(Workout workout) async {
    final finder = Finder(filter: Filter.byKey(workout.sId));
    await _workoutsStore.update(
      await _db,
      workout.toJson(),
      finder: finder,
    );
  }

  Future delete(String workoutId) async {
    final finder = Finder(filter: Filter.byKey(workoutId));
    await _workoutsStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _workoutsStore.delete(
      await _db,
    );
  }

  Future getWorkout(String workoutId) async {
    final finder = Finder(filter: Filter.byKey(workoutId));
    final recordSnapshot = await _workoutsStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshot.map((snapshot) {
      final workout = Workout.fromJson(snapshot.value);
      return workout;
    }).toList();
  }

  // Future getWorkoutsForUser(String userId) async {
  //   final finder = Finder(filter: Filter.equals('clientId', userId));
  //   final recordSnapshot = await _workoutsStore.find(
  //     await _db,
  //     finder: finder,
  //   );

  //   return recordSnapshot.map((snapshot) {
  //     final workout = Workout.fromJson(snapshot.value);
  //     return workout;
  //   }).toList();
  // }

  Future<List<Workout>> getAllSortedByName() async {
    // final finder = Finder(
    //   sortOrders: [
    //     SortOrder('name'),
    //   ],
    // );

    final recordSnapshot = await _workoutsStore.find(
      await _db,
    );

    return recordSnapshot.map((snapshot) {
      final workout = Workout.fromJson(snapshot.value);
      return workout;
    }).toList();
  }
}
