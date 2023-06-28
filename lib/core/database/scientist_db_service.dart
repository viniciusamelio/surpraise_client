import 'package:scientisst_db/scientisst_db.dart';
import '../core.dart';

class ScientistDBService {
  ScientistDBService({
    required this.database,
  });
  final ScientISSTdb database;

  Future<void> add({
    required Json data,
    required String collection,
  }) async {
    await database.collection(collection).add(
          data,
        );
  }

  Future<List<Json>> get<T>({
    required String collection,
    required T equalsTo,
    required String field,
  }) async {
    final results = await database
        .collection(collection)
        .where(
          field,
          isEqualTo: equalsTo,
        )
        .getDocuments();
    return results.map((e) => e.data).toList();
  }

  Future<void> delete<T>({
    required String collection,
    required T equalsTo,
    required String field,
  }) async {
    await database.collection(collection).delete();
  }
}
