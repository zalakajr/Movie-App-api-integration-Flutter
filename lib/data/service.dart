import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieService {
  final String apiToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ZmU0M2NmY2NmNjkzYjExMWY5M2YxOGU1NjY1MTc1NiIsIm5iZiI6MTc0MTM1NzUzNC4yODEsInN1YiI6IjY3Y2IwMWRlMWY5ZWYzNTMyZGFmZGM5NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HhGOPK7SmkOvOaeubHFnzcNRI8jg5rmjaVYZZPzPQ1k';
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Fetch popular movies
  Future<List<dynamic>> fetchPopularMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?language=en-US&page=1'),
      headers: {
        'Authorization': 'Bearer $apiToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']; // List of popular movies
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  // Fetch trending movies
  Future<List<dynamic>> fetchTrendingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/trending/movie/day?page=1'),
      headers: {
        'Authorization': 'Bearer $apiToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']; // List of trending movies
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  // Store genres in a map
  Map<int, String> genreMap = {};

  // Fetch genres and store them in genreMap
  Future<void> fetchGenres() async {
    final response = await http.get(
      Uri.parse('$baseUrl/genre/movie/list?language=en'),
      headers: {
        'Authorization': 'Bearer $apiToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      genreMap = {
        for (var genre in data['genres']) genre['id']: genre['name']
      };
    } else {
      throw Exception('Failed to fetch genres');
    }
  }

  // Convert genre IDs to names
  String getGenresString(List<dynamic> genreIds) {
    return genreIds.map((id) => genreMap[id] ?? 'Unknown').join(', ');
  }
}
