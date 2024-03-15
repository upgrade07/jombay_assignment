import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jombay_assignment/widgets/CharacterCard.dart';

import '../helpers/CharacterService.dart';
import 'CharacterDetailScreen.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

var _characters = [];
var isLoading = true;

class _CharacterScreenState extends State<CharacterScreen> {
  @override
  getData() async {
    _characters = await CharacterService().getCharacters();
    if (_characters != []) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromRGBO(39, 43, 51, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(39, 43, 51, 1),
        title: Text(
          "Rick and Morty",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        elevation: 2,
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _characters.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CharacterDetailScreen(
                                      characterName: _characters[i]["name"],
                                      id: _characters[i]["id"],
                                    )));
                      },
                      child: CharacterCard(
                        name: _characters[i]["name"],
                        imgUrl: _characters[i]["image"],
                        location: _characters[i]["location"]["name"],
                        species: _characters[i]["species"],
                        status: _characters[i]["status"],
                        firstSeen: _characters[i]["origin"]["name"],
                      ),
                    ));
              }),
    ));
  }
}
