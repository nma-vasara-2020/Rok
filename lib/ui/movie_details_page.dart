import 'package:flutter/material.dart';
import 'package:movies/api/movies_api_service.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/movie.dart';

import 'widgets/error_indicator.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/movies_list.dart';

import 'package:share/share.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({Key key, @required this.movie})
      : assert(movie != null, "Please pass a movie as an argument"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: MovieCoverImage(movie: movie),
              title: MovieDetailsHeaderTitle(
                movie: movie,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: MovieDetailsInformation(
              movie: movie,
            ),
          ),
          SliverToBoxAdapter(
            child: MovieDetailsOverview(
              movie: movie,
            ),
          ),
          SliverToBoxAdapter(child: MovieDetailsHeadline(text: "Actors")),
          MovieActorsWidget(movieId: movie.id),
          SliverToBoxAdapter(
            child: MovieDetailsHeadline(text: "Similar movies"),
          ),
          SimilarMoviesWidget(movieId: movie.id),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _shareMovie,
        label: Text("SHARE"),
        icon: Icon(
          Icons.share,
        ),
      ),
    );
  }

  _shareMovie() {
    Share.share("Paziurekite sita filma! ${movie.webUrl}");
    print("something");
  }
}

class MovieDetailsHeaderTitle extends StatelessWidget {
  final Movie movie;

  const MovieDetailsHeaderTitle({Key key, @required this.movie})
      : assert(movie != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      movie.title,
      style: Theme.of(context).textTheme.headline5.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: getTextShadow(
              Colors.black,
              0.2,
            ),
          ),
    );
  }

  // Used to make contrast between image and text
  List<Shadow> getTextShadow(Color color, double d) {
    return [
      Shadow(
          // bottomLeft
          offset: Offset(-d, -d),
          color: color),
      Shadow(
          // bottomRight
          offset: Offset(d, -d),
          color: color),
      Shadow(
          // topRight
          offset: Offset(d, d),
          color: color),
      Shadow(
        // topLeft
        offset: Offset(-d, d),
        color: color,
      )
    ];
  }
}

class MovieDetailsInformation extends StatelessWidget {
  final Movie movie;

  const MovieDetailsInformation({Key key, @required this.movie})
      : assert(movie != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(2),
                  child: Text(
                      "Genres: ${movie.genres.map((e) => e.name).fold("", (value, element) => value + "$element  ")}"),
                ),
                Padding(
                  padding: EdgeInsets.all(2),
                  child: Text("Release date: ${movie.releaseDate}"),
                ),
              ],
            ),
          ),
        ),
        Icon(Icons.star),
        Padding(
          padding: const EdgeInsets.fromLTRB(1, 0, 8, 0),
          child: Text("${movie.voteAverage}"),
        ),
      ],
    );

    //    // TODO Task 8
//    return Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Center(
//        child: Text("TODO Task 8"),
//      ),
//    );
  }
}

class MovieDetailsOverview extends StatelessWidget {
  final Movie movie;

  const MovieDetailsOverview({Key key, @required this.movie})
      : assert(movie != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieDetailsHeadline(
          text: "Overview",
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            movie.overview,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class MovieActorCell extends StatelessWidget {
  final Actor actor;

  const MovieActorCell({Key key, @required this.actor})
      : assert(actor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: (actor.profileUrl == null ? Image.asset("assets/person.jpg", fit: BoxFit.fitWidth) : Image.network(actor.profileUrl, fit: BoxFit.fitWidth)),
          width: 100,
          height: 100,
        ),
        Expanded(
          child: Column(
            children: [
              Text(actor.name),
              Text(actor.character),
            ],
          ),
        ),
      ],
    );
  }
}

class MovieActorsWidget extends StatelessWidget {
  final int movieId;

  const MovieActorsWidget({Key key, @required this.movieId})
      : assert(movieId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MoviesApiService().getMovieActors(movieId),
      builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: ErrorIndicator(error: snapshot.error),
          );
        } else if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final actor = snapshot.data[index];

                return MovieActorCell(
                  actor: actor,
                );
              },
              childCount: snapshot.data.length,
            ),
          );
        }
        return SliverToBoxAdapter(
          child: LoadingIndicator(),
        );
      },
    );
  }

//  const MovieActorsWidget({Key key, @required this.movieId})
//      : assert(movieId != null),
//        super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: Task 9
//    return SliverToBoxAdapter(
//        child: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Center(
//            child: Text("TODO 9"),
//          ),
//        ));
//  }
}

class MovieDetailsHeadline extends StatelessWidget {
  final String text;

  const MovieDetailsHeadline({Key key, @required this.text})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}

class SimilarMoviesWidget extends StatelessWidget {
  final int movieId;

  const SimilarMoviesWidget({Key key, @required this.movieId})
      : assert(movieId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MoviesApiService().getSimilarMovies(movieId),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: ErrorIndicator(error: snapshot.error),
          );
        } else if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final movie = snapshot.data[index];

                return MoviesListViewCell(
                  movie: movie,
                );
              },
              childCount: snapshot.data.length,
            ),
          );
        }
        return SliverToBoxAdapter(
          child: LoadingIndicator(),
        );
      },
    );
  }
}
