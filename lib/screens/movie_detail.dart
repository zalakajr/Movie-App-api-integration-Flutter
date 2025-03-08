import 'package:flutter/material.dart';
class MovieDetailScreen extends StatelessWidget {
  final dynamic movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posterPath = movie['poster_path'];
    final imageUrl = 'https://image.tmdb.org/t/p/w500$posterPath';
    final title = movie['title'] ?? 'No Title';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Container(
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            // Movie Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // Watch and Download Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Add watch functionality
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Watch'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Add download functionality
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: Text('Download'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Row for Overview, Cast, and Related
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Show overview content
                    },
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white, side: BorderSide(color: Colors.white)),
                    child: Text('Overview'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Show cast information
                    },
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white, side: BorderSide(color: Colors.white)),
                    child: Text('Cast'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Show related movies
                    },
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white, side: BorderSide(color: Colors.white)),
                    child: Text('Related'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Movie Overview Text (or additional details)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                movie['overview'] ?? 'No overview available.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}