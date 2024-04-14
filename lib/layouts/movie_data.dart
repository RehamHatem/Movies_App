import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/MovieDetailsResponse.dart';
import '../models/SimilarMoviesResponse.dart';
import '../shared/network/api.dart';
import 'movie_details.dart';

class MovieData extends StatelessWidget {
  int movieId;

  MovieData({super.key, required this.movieId});

  bool addClick = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          APImanager.getMovieDetails(movieId),
          APImanager.getImages(),
          APImanager.getSimilarMovies(movieId)
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("something went wtong",
                style: TextStyle(color: Colors.white));
          }
          var movieDetails = snapshot.data?[0] as MovieDetailsResponse;
          var images = snapshot.data?[1].images ?? [];
          var sameMovie = snapshot.data?[2] as SimilarMoviesResponse;
          List<Results> samMovie = sameMovie.results ?? [];
          if (movieDetails == null) {
            return Center(
                child: Text("No Data", style: TextStyle(color: Colors.white)));
          }
          return Scaffold(
            backgroundColor: Color(0xff121312),
            appBar: AppBar(
              backgroundColor: Color(0xff1D1E1D),
              iconTheme: IconThemeData(color: Colors.white, size: 25),
              title: Text(movieDetails.title ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400)),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              "${images.baseUrl}original${movieDetails.backdropPath ?? ""}",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Icon(
                        Icons.play_circle,
                        size: 50,
                        color: Colors.white,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 10, bottom: 5, right: 16),
                    child: Text(
                      movieDetails.title ?? "",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                    child: Text(
                      movieDetails.releaseDate ?? "",
                      style: TextStyle(
                        color: Color(0xffB5B4B4),
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Container(
                              height: 200,
                              width: 130,
                              padding: EdgeInsets.zero,
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      "${images.baseUrl}original${movieDetails.posterPath}",
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                addClick = !addClick;
                                // setState(() {});
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.bookmark_outlined,
                                    color: addClick
                                        ? Color(0xffF7B539)
                                        : Color(0xff514F4F),
                                    size: 50,
                                  ),
                                  Icon(
                                    addClick ? Icons.check : Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: movieDetails.genres?.map((genre) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Container(
                                              width: 65,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Color(0xffCBCBCB)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                genre.name ?? "",
                                                style: TextStyle(
                                                    color: Color(0xffCBCBCB),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          );
                                        }).toList() ??
                                        [],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  movieDetails.overview ?? "",
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color(0xffFFBB3B),
                                      size: 30,
                                    ),
                                    SizedBox(width: 10),
                                    Text("${movieDetails.voteAverage ?? 0}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 270,
                    padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff282A28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "More Like This ",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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
                              return SingleChildScrollView(
                                child: Container(
                                  height: 250,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xff343534),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, MovieDetails.routeName,
                                          arguments: samMovie[index].id);
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Container(
                                              height: 130,
                                              width: 130,
                                              padding: EdgeInsets.zero,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10)),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl:
                                                      "${images.baseUrl}original${samMovie[index].posterPath ?? ""}",
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                addClick = !addClick;
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.bookmark_outlined,
                                                    color: addClick
                                                        ? Color(0xffF7B539)
                                                        : Color(0xff514F4F),
                                                    size: 50,
                                                  ),
                                                  Icon(
                                                    addClick
                                                        ? Icons.check
                                                        : Icons.add,
                                                    size: 20,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Color(0xffFFBB3B),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "${samMovie[index].voteAverage ?? ""}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${samMovie[index].title ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${samMovie[index].releaseDate}",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xffB5B4B4),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: samMovie.length,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}