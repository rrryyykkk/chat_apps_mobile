import 'package:fe/data/datasources/contact_remote_datasource.dart';
import 'package:fe/data/local/models/local_user.dart';
import 'package:fe/services/isar_service.dart';
import 'package:isar/isar.dart';

class ContactRepository {
  final ContactRemoteDataSource remoteDataSource;
  final IsarService isarService;

  ContactRepository(this.remoteDataSource, this.isarService);

  // Sync contacts from Server to Local
  Future<void> syncContacts() async {
    try {
      final response = await remoteDataSource.getContacts();
      final List<dynamic> data = response.data['data'];

      final isar = await isarService.db;
      
      await isar.writeTxn(() async {
        for (var item in data) {
          final contactId = item['contactId']; // The user ID of the contact
          
          // Check if user exists locally
          var localUser = await isar.localUsers.filter().userIdEqualTo(contactId).findFirst();
          localUser ??= LocalUser();

          localUser.userId = contactId;
          localUser.email = item['email'];
          localUser.name = item['name'];
          localUser.avatarUrl = item['avatarUrl'];
          localUser.color = item['color'];
          localUser.alias = item['alias'];
          localUser.isContact = true;

          await isar.localUsers.put(localUser);
        }
      });
    } catch (e) {
      // Ignore sync error if offline, just use local data
      print("Sync Contacts Failed: $e");
    }
  }

  // Add Contact: Online First -> Then Sync
  Future<void> addContact(String email, String alias) async {
    await remoteDataSource.addContact(email, alias);
    await syncContacts();
  }

  // Get Local Contacts (Stream for UI)
  Stream<List<LocalUser>> listenContacts() async* {
    final isar = await isarService.db;
    yield* isar.localUsers.filter().isContactEqualTo(true).watch(fireImmediately: true);
  }
}
