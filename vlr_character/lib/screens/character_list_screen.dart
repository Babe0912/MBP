import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/character_service.dart';
import '../services/auth_service.dart';

class CharacterListScreen extends StatefulWidget {
  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final CharacterService _characterService = CharacterService();
  final AuthService _authService = AuthService();
  late Future<List<Character>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _charactersFuture = _loadCharacters();
  }

  Future<List<Character>> _loadCharacters() async {
    try {
      return await _characterService.getCharacters();
    } catch (e) {
      // จัดการข้อผิดพลาดถ้าผู้ใช้ไม่มีสิทธิ์
      print('Error loading characters: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          debugPrint(snapshot.toString());  // เพิ่มการพิมพ์ผลลัพธ์เพื่อตรวจสอบ

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No characters found or no permission to view'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final character = snapshot.data![index];
                return ListTile(
                  // ใช้ Text แทนการแสดงภาพจาก URL
                  leading: Text(character.name),
                  title: Text(character.role),
                  subtitle: Text(character.skills),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/character_detail',
                      arguments: character.id,  // ยืนยันว่า id เป็น String
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: _authService.currentUser?.role == 'Admin'
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/character_form');
              },
            )
          : null,
    );
  }
}
