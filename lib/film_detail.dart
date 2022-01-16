import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilmDetailPage extends StatefulWidget {
  var filmDetails;

  FilmDetailPage(this.filmDetails, {Key? key}) : super(key: key);

  @override
  _FilmDetailPageState createState() => _FilmDetailPageState();
}

class _FilmDetailPageState extends State<FilmDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1.0),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            height: 269,
            width: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('${widget.filmDetails.movie_banner}'),
              ),
            boxShadow: <BoxShadow>[
            BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(-6, -6),
            blurRadius: 20,
            ),
            ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
              height: 40,
              width: 300,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${widget.filmDetails.title}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                         ),
                  ),
                ),
              ),
          ),
          Container(
              alignment: Alignment.topCenter,
              height: 25,
              width: 300,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${widget.filmDetails.original_title}' ' - ' '"${widget.filmDetails.original_title_romanised}"' ' (${widget.filmDetails.release_date})',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ),
          Container(
            height: 50,
            width: 300,
            child: Row(
              children: [
                Text('Director: ',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )
                  ),
                ),
                Text('${widget.filmDetails.director}',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),


          Container(
            height: 50,
            width: 300,
            child: Row(
              children: [
                Text('Producer: ',
                textAlign: TextAlign.start,
                style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )
                ),
              ),
                Container(
                  width: 225,
                    child: SingleChildScrollView(
                        child: Text('${widget.filmDetails.producer}',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ))),
              ],
            ),
          ),


          Container(
            height: 50,
            width: 300,
            child: Row(
              children: [
                Text('Rotten Tomatoes Score: ',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )
                  ),
                ),
                Text('${widget.filmDetails.rt_score}' '%',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),


          Container(
            height: 50,
            width: 300,
            child: Row(
              children: [
                Text('Runtime: ',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )
                  ),
                ),
                Text('${widget.filmDetails.running_time}' 'm',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text('Synopsis:',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              ),
                             ),
                            ),
                  ),
                  Container(
                    height: 200,
                    width: 300,
                    child: SingleChildScrollView(
                      child: Text('${widget.filmDetails.description}',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
                ],
                ),

    );
  }
}
