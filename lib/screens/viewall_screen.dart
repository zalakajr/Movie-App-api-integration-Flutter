import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapi/screens/movie_detail.dart';
import 'package:movieapi/screens/search.dart';
import 'package:movieapi/widgets/shimmer_loader.dart';

class ViewAllScreen extends StatelessWidget {
  final String title;
  final Future<List<dynamic>> moviesFuture;

  const ViewAllScreen(
      {Key? key, required this.title, required this.moviesFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey[400],
          ),
        ),
        title: Text(title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Search()));
              },
              child: Icon(
                Icons.search,
                color: Colors.grey[400],
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<dynamic>>(
        future: moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
             
                child: Center(
                    child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
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
               
                child: Center(
                    child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
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
            return Center(
                child: Text('No movies found',
                    style: TextStyle(color: Colors.white)));
          } else {
            final movies = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final posterPath = movie['poster_path'];
                final imageUrl = 'https://image.tmdb.org/t/p/w500$posterPath';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(movie: movie)),
                    );
                  },
                  child: Card(
                    color: const Color.fromARGB(64, 48, 48, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie['title'] ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
