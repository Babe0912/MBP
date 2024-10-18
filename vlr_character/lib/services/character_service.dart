import 'package:pocketbase/pocketbase.dart';
import '../models/character.dart';

class CharacterService {
  final PocketBase pb = PocketBase('http://127.0.0.1:8090');

  Future<List<Character>> getCharacters() async {
    try {
      final records = await pb.collection('character').getFullList();
      print('Fetched records: ${records.map((r) => r.toJson())}');  // เพิ่มการพิมพ์ข้อมูลที่ดึงมา
      return records.map((record) => Character.fromJson(record.toJson())).toList();
    } catch (e) {
      print('Error fetching characters: $e');
      return [];
    }
  }

  Future<Character> getCharacter(String id) async {
    final record = await pb.collection('character').getOne(id);
    return Character.fromJson(record.toJson());
  }

  Future<Character> createCharacter(Character character) async {
    final record = await pb.collection('character').create(body: {
      'avatar': character.name,
      'role': character.role,
      'skills': character.skills,
    });
    return Character.fromJson(record.toJson());
  }

  Future<Character> updateCharacter(Character character) async {
    final record = await pb.collection('character').update(character.id, body: {
      'avatar': character.name,
      'role': character.role,
      'skills': character.skills,
    });
    return Character.fromJson(record.toJson());
  }

  Future<void> deleteCharacter(String id) async {
    await pb.collection('character').delete(id);
  }
}
