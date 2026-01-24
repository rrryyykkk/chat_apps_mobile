import 'package:isar/isar.dart';

part 'local_user.g.dart';

@collection
class LocalUser {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String userId; // ID from Backend

  late String email;
  late String name;
  String? avatarUrl;
  String? color;
  
  // Contact specific fields
  bool isContact = false;
  String? alias; // Local nickname

  DateTime? lastSeen;
}
