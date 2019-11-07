import 'package:sembast/sembast.dart';
import '../data/app_database.dart';
import './exercise.dart';

class ExerciseDao {
  static const String EXERCISE_STORE_NAME = 'exercises';

  final _exerciseStore = stringMapStoreFactory.store(EXERCISE_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Exercise exercise) async {
    await _exerciseStore.add(await _db, exercise.toJson());
  }

  Future update(Exercise exercise) async {
    final finder = Finder(filter: Filter.equals('name', exercise.name));
    await _exerciseStore.update(
      await _db,
      exercise.toJson(),
      finder: finder,
    );
  }

  Future delete(Exercise exercise) async {
    final finder = Finder(filter: Filter.equals('name', exercise.name));
    await _exerciseStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future getExercise(String exerciseId) async {
    final finder = Finder(filter: Filter.equals('_id', exerciseId));
    final recordSnapshot = await _exerciseStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshot.map((snapshot) {
      final exercise = Exercise.fromJson(snapshot.value);
      return exercise;
    }).toList();
  }

  Future<List<Exercise>> getAllSortedByName() async {
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshot = await _exerciseStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshot.map((snapshot) {
      final exercise = Exercise.fromJson(snapshot.value);
      return exercise;
    }).toList();
  }
}
