import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapi/data/service.dart';
import 'package:movieapi/screens/movie_detail.dart';
import 'package:movieapi/screens/search.dart';
import 'package:movieapi/screens/viewall_screen.dart';
// Added for dynamic color extraction.
import 'package:palette_generator/palette_generator.dart';

class MovieHomePage extends StatefulWidget {
  @override
  _MovieHomePageState createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  late Future<List<dynamic>> popularMovies;
  late Future<List<dynamic>> trendingMovies;
  late Future<List<dynamic>> latestMovies;
  late Future<List<dynamic>> tvSeries;

  int _currentCarouselIndex = 0;
  // Dynamic background color for carousel section and app bar.
  Color _carouselBgColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Fetch movies from MovieService.
    popularMovies = MovieService().fetchPopularMovies();
    trendingMovies = MovieService().fetchTrendingMovies();
    latestMovies = MovieService().fetchLatestMovies();
    tvSeries = MovieService().fetchTvSeries();
  }

  // Update the background color by extracting the dominant color from the image.
  Future<void> updatePalette(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));
    if (mounted) {
      setState(() {
        _carouselBgColor =
            paletteGenerator.dominantColor?.color ?? Colors.black;
      });
    }
  }

  Widget buildSection(String title, Future<List<dynamic>> moviesFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with title and View All text.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              GestureDetector(
                onTap: () {
                  // Navigate to a new screen that shows all movies for this category.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAllScreen(
                        title: title,
                        moviesFuture: moviesFuture,
                      ),
                    ),
                  );
                },
                child: Text(
                  "View All",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        // Horizontal list view.
        FutureBuilder<List<dynamic>>(
          future: moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: 250,
                  child: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Container(
                  height: 250,
                  child: Center(
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.white))));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                  height: 250,
                  child: Center(
                      child: Text('No movies found',
                          style: TextStyle(color: Colors.white))));
            } else {
              final movies = snapshot.data!;
              return Container(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    final posterPath = movie['poster_path'];
                    final imageUrl =
                        'https://image.tmdb.org/t/p/w500$posterPath';
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movie: movie)),
                        );
                      },
                      child: Container(
                        width: 150,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              movie['title'] ?? '',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend body behind app bar to allow a continuous gradient.
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      // Make the app bar transparent so the gradient shows through.
      appBar: AppBar(
        scrolledUnderElevation: 7,
        
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Text('Moviex', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Search()));
                  },
                  icon: Icon(Icons.search, color: Colors.grey[400]),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Using a Stack to place a gradient background behind the app bar and carousel.
      body: Stack(
        children: [
          
          // Gradient background covering app bar and carousel section.
          Container(
            height: kToolbarHeight + 350 + 16, // app bar + carousel height + padding
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _carouselBgColor.withOpacity(0.7),
                  Colors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add top spacing to account for the app bar.
                  SizedBox(height: kToolbarHeight + 16),
                  // Popular Movies Carousel Section (without its own gradient wrapper).
                  FutureBuilder<List<dynamic>>(
                    future: popularMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            height: 350,
                            child: Center(child: CircularProgressIndicator()));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.white)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No movies found',
                                style: TextStyle(color: Colors.white)));
                      } else {
                        final movies = snapshot.data!;
                        // On first build, update the gradient using the first movie's poster.
                        if (movies.isNotEmpty && _carouselBgColor == Colors.black) {
                          final posterPath = movies[0]['poster_path'];
                          final imageUrl =
                              'https://image.tmdb.org/t/p/w500$posterPath';
                          updatePalette(imageUrl);
                        }
                        return Column(

                          
                          children: [
                            SizedBox(height: 60,),

                           
                            CarouselSlider.builder(
                              itemCount: movies.length,
                              itemBuilder: (context, index, realIndex) {
                                final movie = movies[index];
                                final posterPath = movie['poster_path'];
                                final imageUrl =
                                    'https://image.tmdb.org/t/p/w500$posterPath';
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailScreen(movie: movie),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        width: 250,
                                        height: 300,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: 350,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: true,
                                viewportFraction: 0.6,
                                autoPlay: true,
                                initialPage: 0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentCarouselIndex = index;
                                  });
                                  // Update the gradient background based on the current movie's poster.
                                  final movie = movies[index];
                                  final posterPath = movie['poster_path'];
                                  final imageUrl =
                                      'https://image.tmdb.org/t/p/w500$posterPath';
                                  updatePalette(imageUrl);
                                },
                              ),
                            ),
                            // Display the title of the currently centered movie.
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                movies[_currentCarouselIndex]['title'] ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                            ),
                            Text(
                              'Detail',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[400]),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.limeAccent),
                          child: Center(
                            child: Text(
                              'Watch Now',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.grey,
                            ),
                            Text(
                              'Detail',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[400]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Additional sections.
                  buildSection("Trending", trendingMovies),
                  buildSection("Popular", popularMovies),
                  buildSection("Latest Movies", latestMovies),
                  buildSection("TV Series", tvSeries),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
