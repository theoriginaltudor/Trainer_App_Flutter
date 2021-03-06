import 'package:sembast/sembast.dart';
import '../data/app_database.dart';
import './exercise.dart';

class ExerciseDao {
  static const String EXERCISE_STORE_NAME = 'exercises';

  final _exerciseStore = stringMapStoreFactory.store(EXERCISE_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<List<Exercise>> insert(Exercise exercise) async {
    if (exercise.sId == null) {
      var key = await _exerciseStore.add(await _db, exercise.toJson());
      exercise.sId = key;
      await update(exercise);
    } else {
      await _exerciseStore
          .record(exercise.sId)
          .put(await _db, exercise.toJson());
    }

    return <Exercise>[exercise];
  }

  Future update(Exercise exercise) async {
    final finder = Finder(filter: Filter.byKey(exercise.sId));
    await _exerciseStore.update(
      await _db,
      exercise.toJson(),
      finder: finder,
    );
  }

  Future delete(String exerciseId) async {
    final finder = Finder(filter: Filter.byKey(exerciseId));
    await _exerciseStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _exerciseStore.delete(
      await _db,
    );
  }

  Future getExercise(String exerciseId) async {
    final finder = Finder(filter: Filter.byKey(exerciseId));
    final recordSnapshot = await _exerciseStore.find(
      await _db,
      finder: finder,
    );
    return recordSnapshot.map((snapshot) {
      // print("exercise_dao " + snapshot.value);
      final exercise = Exercise.fromJson(snapshot.value);
      return exercise;
    }).toList();
  }

  Future getExercises(List<String> exerciseIds) async {
    List<Filter> filters = [];
    for (var id in exerciseIds) {
      filters.add(Filter.byKey(id));
    }
    final finder = Finder(filter: Filter.or(filters));
    final recordSnapshot = await _exerciseStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshot.map((snapshot) {
      final exercise = Exercise.fromJson(snapshot.value);
      return exercise;
    }).toList();
  }

  Future<List<Exercise>> getAllData() async {
    // final finder = Finder(sortOrders: [
    //   SortOrder('name'),
    // ]);

    final recordSnapshot = await _exerciseStore.find(
      await _db,
    );

    return recordSnapshot.map((snapshot) {
      final exercise = Exercise.fromJson(snapshot.value);
      return exercise;
    }).toList();
  }
}
