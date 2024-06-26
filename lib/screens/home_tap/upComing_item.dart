import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../../layouts/home_layouts/movie_details.dart';
import '../../models/home_models/ImagesResponce.dart';
import '../../models/home_models/UpComingResponse.dart';
import '../../shared/firebase/firebase_functions.dart';
import '../../shared/firebase/movie_model.dart';

class UpComItem extends StatefulWidget {
  List<Results> upResults;
  Images images;

  UpComItem({Key? key, required this.upResults, required this.images})
      : super(key: key);

  @override
  State<UpComItem> createState() => _UpComItemState();
}

class _UpComItemState extends State<UpComItem> {
  List<bool> addClick = [];
  void initState() {
    super.initState();
    addClick = List.filled(widget.upResults.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 187,
      padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xff282A28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Releases ",
            style: TextStyle(
              fontSize: 15,
              fontWeight:FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 10,
                );
              },
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    InkWell(
                      onTap:(){
                        Navigator.pushNamed(context, MovieDetails.routeName,arguments: widget.upResults[index].id);
                      },
                      child: Container(
                        height: 127,
                        width: 96,
                        padding: EdgeInsets.zero,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),

                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: "${widget.images.baseUrl}original${widget.upResults[index].posterPath}",
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),),
                      ),
                    ),
                    InkWell(
                      onTap: () {

                        setState(() {
                          addClick[index] = !addClick[index];
                          if(addClick[index]==true){
                            MovieModel movieModel = MovieModel(
                              addclick: addClick[index],
                              movieId: widget.upResults[index].id,
                              title: widget.upResults[index].title,
                              posterPath: widget.upResults[index].posterPath,
                              releaseDate: widget.upResults[index].releaseDate,
                              voteAverage: widget.upResults[index].voteAverage,
                              genreIds: widget.upResults[index].genreIds,
                              backdropPath: widget.upResults[index].backdropPath,
                              overview: widget.upResults[index].overview,
                              adult: widget.upResults[index].adult,
                              originalLanguage: widget.upResults[index].originalLanguage,
                              originalTitle: widget.upResults[index].originalTitle,
                              popularity: widget.upResults[index].popularity,
                              video: widget.upResults[index].video,
                              voteCount: widget.upResults[index].voteCount,
                            );

                            Firebasefunctions.addmovie(movieModel);

                          }

                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_outlined,
                            color: addClick[index]
                                ? Color(0xffF7B539)
                                : Color(0xff514F4F),
                            size: 50,
                          ),
                          Icon(
                            addClick[index] ? Icons.check : Icons.add,
                            size: 20,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
              itemCount: widget.upResults.length,
            ),
          ),
        ],
      ),
    );
  }
}
