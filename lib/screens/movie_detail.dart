import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movieapi/data/service.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieDetailScreen extends StatefulWidget {
  final dynamic movie;
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<List<dynamic>> popularMovies;
  late Future<List<dynamic>> trendingMovies;
  Color _backgroundColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _updatePalette();
    popularMovies = MovieService().fetchPopularMovies();
    trendingMovies = MovieService().fetchTrendingMovies();
  }

  // Extract dominant color from the backdrop image and update the background color.
  Future<void> _updatePalette() async {
    final backDropPath = widget.movie['backdrop_path'];
    final imagebgUrl = 'https://image.tmdb.org/t/p/w500$backDropPath';
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(imagebgUrl));
    setState(() {
      _backgroundColor = paletteGenerator.dominantColor?.color ?? Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    final posterPath = widget.movie['poster_path'];
    final backDropPath = widget.movie['backdrop_path'];
    final lang = widget.movie['original_language'];
    final vote = widget.movie['vote_average'];
    final voteCount = widget.movie['vote_count'];
    final releasDate = widget.movie['release_date'];
    final imageUrl = 'https://image.tmdb.org/t/p/w500$posterPath';
    final imagebgUrl = 'https://image.tmdb.org/t/p/w500$backDropPath';
    final title = widget.movie['title'] ?? 'No Title';
    String year = DateTime.parse(releasDate).year.toString();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[300],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.share,
                color: Colors.grey[300],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The top section: background image with gradient/blur overlay,
            // and the overlaid content (thumbnail, movie info, buttons).
            Container(
              height: 500, // Increase this height to include buttons area
              child: Stack(
                children: [
                  // Background image
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 400, // height for the backdrop image
                    child: Image.network(
                      imagebgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient + blur overlay that extends from near the bottom of the image downwards
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black, // Fully black at the bottom
                          ],
                        ),
                      ),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            // Use a transparent container for the blur to take effect.
                            color: Colors.black.withOpacity(0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Positioned content: thumbnail, movie info row.
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 110,
                    child: Container(
                      height: 150,
                      child: Row(
                        children: [
                          // Thumbnail image
                          Container(
                            width: 90,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          // Movie info: title, rating, language, year.
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 15,
                                      color: Colors.lime,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${vote.toString()}(${voteCount.toString()})",
                                      style: TextStyle(color: Colors.lime),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      lang,
                                      style: TextStyle(
                                          color: Colors.grey.shade300),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      year,
                                      style: TextStyle(
                                          color: Colors.grey.shade300),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Positioned Watch and Download buttons over the gradient area.
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Watch function
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.limeAccent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Watch Now',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.play_circle_fill),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Download function
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[700]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Download',
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.download,
                                    color: Colors.grey[300],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Other content: Overview, Cast, Related Buttons, and Overview Text.
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text('Overview'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text('Cast'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text('Related'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.movie['overview'] ?? 'No overview available.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
