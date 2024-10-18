import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/character_service.dart';
import '../services/auth_service.dart';

class CharacterDetailScreen extends StatelessWidget {
  final CharacterService _characterService = CharacterService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final String characterId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Character Detail')),
      body: FutureBuilder<Character>(
        future: _characterService.getCharacter(characterId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No character found'));
          } else {
            final character = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(character.name, style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 16),
                  Text('Role: ${character.role}', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 8),
                  Text('Skills: ${character.skills}'),
                  if (_authService.currentUser?.role == 'Admin') ...[
                    SizedBox(height: 16),
                    ElevatedButton(
                      child: Text('Edit'),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/character_form',
                          arguments: character,
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      child: Text('Delete'),
                      onPressed: () async {
                        await _characterService.deleteCharacter(character.id);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
