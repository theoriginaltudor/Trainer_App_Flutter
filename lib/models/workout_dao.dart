import 'package:sembast/sembast.dart';
import 'package:trainer_app_flutter/models/workout.dart';
import '../data/app_database.dart';

class WorkoutDao {
  static const String WORKOUTS_STORE_NAME = 'workouts';

  final _workoutsStore = stringMapStoreFactory.store(WORKOUTS_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Workout workout) async {
    List duplicate = await getWorkout(workout.sId);
    if (duplicate.isEmpty) {
      await _workoutsStore.record(workout.sId).put(await _db, workout.toJson());
    }
  }

  Future update(Workout workout) async {
    final finder = Finder(filter: Filter.byKey(workout.sId));
    await _workoutsStore.update(
      await _db,
      workout.toJson(),
      finder: finder,
    );
  }

  Future delete(Workout workout) async {
    final finder = Finder(filter: Filter.byKey(workout.sId));
    await _workoutsStore.delete(
      await _db,
      finder: finder,
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

  Future<List<Workout>> getAllSortedByName() async {
    final finder = Finder(
      sortOrders: [
        SortOrder('name'),
      ],
    );

    final recordSnapshot = await _workoutsStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshot.map((snapshot) {
      final workout = Workout.fromJson(snapshot.value);
      return workout;
    }).toList();
  }
}
