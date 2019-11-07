import 'package:sembast/sembast.dart';
import 'package:trainer_app_flutter/models/history.dart';
import '../data/app_database.dart';

class HistoryDao {
  static const String HISTORY_STORE_NAME = 'history';

  final _historyStore = stringMapStoreFactory.store(HISTORY_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(History history) async {
    await _historyStore.add(await _db, history.toJson());
  }

  Future update(History history) async {
    final finder = Finder(filter: Filter.equals('_id', history.sId));
    await _historyStore.update(
      await _db,
      history.toJson(),
      finder: finder,
    );
  }

  Future delete(History history) async {
    final finder = Finder(filter: Filter.equals('_id', history.sId));
    await _historyStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future getHistory(String historyId) async {
    final finder = Finder(filter: Filter.equals('_id', historyId));
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
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshot = await _historyStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshot.map((snapshot) {
      final history = History.fromJson(snapshot.value);
      return history;
    }).toList();
  }
}
