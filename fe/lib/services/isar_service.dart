import 'package:fe/data/local/models/local_chat.dart';
import 'package:fe/data/local/models/local_message.dart';
import 'package:fe/data/local/models/local_user.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [LocalUserSchema, LocalChatSchema, LocalMessageSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }
}
