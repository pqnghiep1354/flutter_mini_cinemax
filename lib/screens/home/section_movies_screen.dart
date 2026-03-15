import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../repos/movie_repo.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_widget.dart';
import '../home/widgets/home_movie_card.dart';

enum MovieSectionType { nowPlaying, popular, topRated, upcoming }

class SectionMoviesScreen extends StatefulWidget {
  final String title;
  final MovieSectionType sectionType;

  const SectionMoviesScreen({
    super.key,
    required this.title,
    required this.sectionType,
  });

  @override
  State<SectionMoviesScreen> createState() => _SectionMoviesScreenState();
}

class _SectionMoviesScreenState extends State<SectionMoviesScreen> {
  final MovieRepo _movieRepo = MovieRepo();
  final List<Movie> _movies = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _fetchBySection(_currentPage);
      setState(() {
        _movies.addAll(results);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentPage++;
      final results = await _fetchBySection(_currentPage);
      setState(() {
        _movies.addAll(results);
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<List<Movie>> _fetchBySection(int page) async {
    switch (widget.sectionType) {
      case MovieSectionType.nowPlaying:
        return _movieRepo.getNowPlaying(page: page);
      case MovieSectionType.popular:
        return _movieRepo.getPopular(page: page);
      case MovieSectionType.topRated:
        return _movieRepo.getTopRated(page: page);
      case MovieSectionType.upcoming:
        return _movieRepo.getUpcoming(page: page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _movies.isEmpty) {
      return const LoadingIndicator();
    }

    if (_errorMessage != null && _movies.isEmpty) {
      return AppErrorWidget(
        message: _errorMessage!,
        onRetry: _loadMovies,
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: _movies.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _movies.length) {
          return HomeMovieCard(movie: _movies[index]);
        }
        return const Center(child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}
