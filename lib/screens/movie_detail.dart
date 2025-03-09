import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movieapi/data/service.dart';
import 'package:movieapi/widgets/shimmer_loader.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieDetailScreen extends StatefulWidget {
  final dynamic movie;
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Color _backgroundColor = Colors.black;
  late Future<List<dynamic>> castFuture;
  late Future<List<dynamic>> relatedFuture;
  int _selectedSection = 0; // 0: Overview, 1: Cast, 2: Related

  @override
  void initState() {
    super.initState();
    // Uncomment the next line if you want to extract the background color from the backdrop.
    // _updatePalette();
    final int movieId = widget.movie['id'];
    castFuture = MovieService().fetchCast(movieId);
    relatedFuture = MovieService().fetchRelatedMovies(movieId);
  }

  // Extract dominant color from the backdrop image and update the background color.
  // Future<void> _updatePalette() async {
  //   final backDropPath = widget.movie['backdrop_path'];
  //   final imagebgUrl = 'https://image.tmdb.org/t/p/w500$backDropPath';
  //   final PaletteGenerator paletteGenerator =
  //       await PaletteGenerator.fromImageProvider(NetworkImage(imagebgUrl));
  //   setState(() {
  //     _backgroundColor = paletteGenerator.dominantColor?.color ?? Colors.black;
  //   });
  // }

  // Widget to display the "Overview" section
  Widget _buildOverviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        widget.movie['overview'] ?? 'No overview available.',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // Widget to display the "Cast" section
  Widget _buildCastSection() {
    return FutureBuilder<List<dynamic>>(
      future: castFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: 250,
              child: Center(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => ShimmerLoader(
                  width: 100,
                  height: 100,
                  isCircular: true,
                ),
              )));
        } else if (snapshot.hasError) {
          return Container(
              height: 250,
              child: Center(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => ShimmerLoader(
                  width: 100,
                  height: 100,
                  isCircular: true,
                ),
              )));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No cast available',
                  style: TextStyle(color: Colors.white)));
        } else {
          final castList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: castList.length,
                itemBuilder: (context, index) {
                  final castMember = castList[index];
                  final profilePath = castMember['profile_path'];
                  final castImageUrl = profilePath != null
                      ? 'https://image.tmdb.org/t/p/w200$profilePath'
                      : 'https://via.placeholder.com/200x300?text=No+Image';
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(castImageUrl),
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 100,
                          child: Text(
                            castMember['name'] ?? 'Unknown',
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  // Widget to display the "Related" section as a grid.
  Widget _buildRelatedSection() {
    return FutureBuilder<List<dynamic>>(
      future: relatedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: 250,
              child: Center(
                  child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: .6),
               
                itemCount: 10,
                itemBuilder: (context, index) => ShimmerLoader(
                  width: 100,
                  height: 150,
                  isCircular: false,
                ),
              )));
        } else if (snapshot.hasError) {
          return Container(
              height: 250,
              child: Center(
                  child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: .6),
              
                itemCount: 10,
                itemBuilder: (context, index) => ShimmerLoader(
                  width: 100,
                  height: 150,
                  isCircular: false,
                ),
              )));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No related movies available',
                  style: TextStyle(color: Colors.white)));
        } else {
          final relatedMovies = snapshot.data!;
          return GridView.builder(
            
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.6),
            itemCount: relatedMovies.length,
            itemBuilder: (context, index) {
              final relatedMovie = relatedMovies[index];
              final posterPath = relatedMovie['poster_path'];
              final relatedImageUrl = posterPath != null
                  ? 'https://image.tmdb.org/t/p/w200$posterPath'
                  : 'https://via.placeholder.com/200x300?text=No+Image';
              return GestureDetector(
                onTap: () {
                  // Navigate to another MovieDetailScreen if desired.
                },
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(relatedImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 100,
                      child: Text(
                        relatedMovie['title'] ?? 'Unknown',
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  // Build the section buttons (Overview, Cast, Related)
  Widget _buildSectionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          // overview button
          OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedSection = 0;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  _selectedSection == 0 ? Colors.lime : Colors.grey,
              side: BorderSide(
                  color: _selectedSection == 0 ? Colors.lime : Colors.grey),
            ),
            child: const Text('Overview'),
          ),

          // Cast button

          OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedSection = 1;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  _selectedSection == 1 ? Colors.lime : Colors.grey,
              side: BorderSide(
                  color: _selectedSection == 1 ? Colors.lime : Colors.grey),
            ),
            child: const Text('Cast'),
          ),

          //Related button
          OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedSection = 2;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  _selectedSection == 2 ? Colors.lime : Colors.grey,
              side: BorderSide(
                  color: _selectedSection == 2 ? Colors.lime : Colors.grey),
            ),
            child: const Text('Related'),
          ),
        ],
      ),
    );
  }

  // Build the content based on the selected section.
  Widget _buildSectionContent() {
    if (_selectedSection == 0) {
      return _buildOverviewSection();
    } else if (_selectedSection == 1) {
      return _buildCastSection();
    } else if (_selectedSection == 2) {
      return _buildRelatedSection();
    }
    return Container();
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
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.share, color: Colors.grey[300]),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Backdrop with gradient/blur, overlaid with thumbnail & movie info and buttons.
            Container(
              height: 500,
              child: Stack(
                children: [
                  // Backdrop image.
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 400,
                    child: Image.network(
                      imagebgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient + blur overlay.
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black,
                          ],
                        ),
                      ),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            color: Colors.black.withOpacity(0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Positioned movie info: Thumbnail, title, rating, language, year.
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 110,
                    child: Container(
                      height: 150,
                      child: Row(
                        children: [
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
                                    Icon(Icons.star,
                                        size: 15, color: Colors.lime),
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
                  // Positioned Watch and Download buttons.
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
                                  Icon(Icons.download, color: Colors.grey[300]),
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
            SizedBox(height: 16),
            // Section buttons: Overview, Cast, Related.
            _buildSectionButtons(),

            // Display section content based on the selected tab.
            _buildSectionContent(),
          ],
        ),
      ),
    );
  }
}
