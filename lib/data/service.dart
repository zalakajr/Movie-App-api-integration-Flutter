import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieService {
  final String apiToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ZmU0M2NmY2NmNjkzYjExMWY5M2YxOGU1NjY1MTc1NiIsIm5iZiI6MTc0MTM1NzUzNC4yODEsInN1YiI6IjY3Y2IwMWRlMWY5ZWYzNTMyZGFmZGM5NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HhGOPK7SmkOvOaeubHFnzcNRI8jg5rmjaVYZZPzPQ1k';
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

// fetch latest Movies
  Future<List<dynamic>> fetchLatestMovies() async {
  final response = await http.get(
    Uri.parse('$baseUrl/movie/now_playing?language=en-US&page=1'),
    headers: {
      'Authorization': 'Bearer $apiToken',
      'accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['results'];
  } else {
    throw Exception('Failed to load latest movies');
  }
}

// fetch tv series

Future<List<dynamic>> fetchTvSeries() async {
  final response = await http.get(
    Uri.parse('$baseUrl/tv/popular?language=en-US&page=1'),
    headers: {
      'Authorization': 'Bearer $apiToken',
      'accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['results'];
  } else {
    throw Exception('Failed to load TV series');
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

// Fetch cast details
Future<List<dynamic>> fetchCast(int movieId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiToken'),
    headers: {
      'Authorization': 'Bearer $apiToken',
      'accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['cast']; // List of cast members
  } else {
    throw Exception('Failed to load cast');
  }
}

// Fetch related movies
Future<List<dynamic>> fetchRelatedMovies(int movieId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiToken'),
    headers: {
      'Authorization': 'Bearer $apiToken',
      'accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['results']; // List of related movies
  } else {
    throw Exception('Failed to load related movies');
  }
}



}
