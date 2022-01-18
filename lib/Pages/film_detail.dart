import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            height: 250.h,
            width: 500.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('${widget.filmDetails.movie_banner}'),
                fit: BoxFit.fill,
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
              height: 40.h,
              width: 300.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${widget.filmDetails.title}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                         ),
                  ),
                ),
              ),
          ),
          Container(
              alignment: Alignment.topCenter,
              height: 25.h,
              width: 300.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${widget.filmDetails.original_title}' ' - ' '"${widget.filmDetails.original_title_romanised}"' ' (${widget.filmDetails.release_date})',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
          ),
          Container(
            height: 50.h,
            width: 300.w,
            child: Row(
              children: [
                Text('Director: ',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    )
                  ),
                ),
                Text('${widget.filmDetails.director}',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),


          Container(
            height: 50.h,
            width: 300.w,
            child: Row(
              children: [
                Text('Producer: ',
                textAlign: TextAlign.start,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    )
                ),
              ),
                Container(
                  width: 225.w,
                    child: SingleChildScrollView(
                        child: Text('${widget.filmDetails.producer}',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                            ),
                          ),
                        ))),
              ],
            ),
          ),


          Container(
            height: 50.h,
            width: 300.w,
            child: Row(
              children: [
                Text('Rotten Tomatoes Score: ',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      )
                  ),
                ),
                Text('${widget.filmDetails.rt_score}' '%',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),


          Container(
            height: 50.h,
            width: 300.w,
            child: Row(
              children: [
                Text('Runtime: ',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      )
                  ),
                ),
                Text('${widget.filmDetails.running_time}' 'm',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
              width: 300.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30.h,
                    alignment: Alignment.centerLeft,
                    child: Text('Synopsis:',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              ),
                             ),
                            ),
                  ),
                  Container(
                    height: 200.h,
                    width: 300.w,
                    child: SingleChildScrollView(
                      child: Text('${widget.filmDetails.description}',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
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
