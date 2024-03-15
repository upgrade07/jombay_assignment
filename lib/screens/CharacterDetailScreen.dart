import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/CharacterService.dart';
import '../widgets/CharacterCard.dart';

class CharacterDetailScreen extends StatefulWidget {
  final String characterName;
  final int id;
  const CharacterDetailScreen(
      {super.key, required this.characterName, required this.id});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

var _characterDetails = {};
var isLoading = true;
var episodesLoading = true;
var episodes = [];
var episodeData = [];
var singleEpData = {};

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  getData() async {
    _characterDetails = await CharacterService().getCharacterDetails(widget.id);
    episodes = _characterDetails["episode"];

    if (_characterDetails != {}) {
      setState(() {
        isLoading = false;
      });
    }
    for (var i = 0; i < episodes.length; i++) {
      var singleEpData = await CharacterService().fetchEpisodeData(episodes[i]);
      episodeData.add(singleEpData);
    }
    print(episodeData);
    setState(() {
      episodesLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
      episodesLoading = true;
    });
    getData();
    super.initState();
  }

  @override
  void dispose() {
    episodeData = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromRGBO(39, 43, 51, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(39, 43, 51, 1),
        title: Text(
          widget.characterName.toString(),
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  CharacterCard(
                    name: _characterDetails["name"],
                    imgUrl: _characterDetails["image"],
                    location: _characterDetails["location"]["name"],
                    species: _characterDetails["species"],
                    status: _characterDetails["status"],
                    firstSeen: _characterDetails["origin"]["name"],
                  ),
                  episodesLoading
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.2),
                          child: Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 24, left: 8, right: 8),
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: episodeData.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(39, 43, 51, 1),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1, color: Colors.grey)
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          episodeData[index]['episode'],
                                          style: GoogleFonts.poppins(
                                              color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        episodeData[index]['name'],
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          episodeData[index]['air_date'],
                                          style: GoogleFonts.poppins(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                ],
              ),
            ),
    ));
  }
}
