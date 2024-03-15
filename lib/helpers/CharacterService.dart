import 'dart:convert';

import 'package:http/http.dart' as http;

class CharacterService {
  Future<List> getCharacters() async {
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character'),
      headers: {"Content-Type": "application/json"},
    );
    var data = await jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['results'];
    } else {
      return [];
    }
  }

  Future<Map> getCharacterDetails(id) async {
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character/${id}'),
      headers: {"Content-Type": "application/json"},
    );
    var data = await jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else
      return {};
  }

  Future<Map> fetchEpisodeData(url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    var data = await jsonDecode(response.body);

    return data;
  }
}
