import 'package:sembast/sembast.dart';
import 'package:trainer_app_flutter/models/history.dart';
import '../data/app_database.dart';

class HistoryDao {
  static const String HISTORY_STORE_NAME = 'history';

  final _historyStore = stringMapStoreFactory.store(HISTORY_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<List<History>> insert(History history) async {
    if (history.sId == null) {
      var key = await _historyStore.add(await _db, history.toJson());
      history.sId = key;
      await update(history);
    } else {
      await _historyStore
          .record(history.sId)
          .put(await _db, history.toJson(withIds: true));
    }
    return <History>[history];
  }

  Future update(History history) async {
    final finder = Finder(filter: Filter.byKey(history.sId));
    await _historyStore.update(
      await _db,
      history.toJson(withIds: true),
      finder: finder,
    );
  }

  Future delete(String historyId) async {
    final finder = Finder(filter: Filter.byKey(historyId));
    await _historyStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _historyStore.delete(
      await _db,
    );
  }

  Future getHistory(String historyId) async {
    final finder = Finder(filter: Filter.byKey(historyId));
    final recordSnapshot = await _historyStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshot.map((snapshot) {
      final history = History.fromJson(snapshot.value);
      return history;
    }).toList();
  }

  Future getHistoryForExercise(String exerciseId) async {
    final finder = Finder(filter: Filter.equals("clientId", exerciseId));
    final recordSnapshot = await _historyStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshot.map((snapshot) {
      final history = History.fromJson(snapshot.value);
      return history;
    }).toList();
  }

  Future getHistoryForWorkout(String workoutId) async {
    final finder = Finder(filter: Filter.equals("workoutId", workoutId));
    final recordSnapshot = await _historyStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshot.map((snapshot) {
      final history = History.fromJson(snapshot.value);
      return history;
    }).toList();
  }

  Future<List<History>> getAllSortedByName() async {
    // final finder = Finder(sortOrders: [
    //   SortOrder('name'),
    // ]);

    final recordSnapshot = await _historyStore.find(
      await _db,
    );

    return recordSnapshot.map((snapshot) {
      final history = History.fromJson(snapshot.value);
      return history;
    }).toList();
  }
}
