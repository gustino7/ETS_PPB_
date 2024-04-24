import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbb_sqflite/database/db.dart';
import 'package:pbb_sqflite/model/db_model.dart';
import 'package:pbb_sqflite/widget/movie_widget.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  Future<List<Model>>? futureMovie;
  final movieDB = Db();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMovie();
  }

  void fetchMovie(){
    setState(() {
      futureMovie = movieDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: FutureBuilder<List<Model>>(
        future: futureMovie,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else{
            final movies = snapshot.data!;

            return movies.isEmpty ? const Center(
              child: Text(
                'No Movie Has Been Added...',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30
                ),
              ),
            ) : ListView.separated(
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  final subtitle = DateFormat('yyyy/MM/dd').format(
                      DateTime.parse(movie.updatedAt ?? movie.createdAt)
                  );
                  return ListTile(
                    title: Text(
                      movie.title,
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(subtitle),
                    trailing: IconButton(
                      onPressed: () async {
                        await movieDB.delete(movie.id);
                        fetchMovie();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    onTap: (){
                      // UPDATE MOVIE
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => CreateMovieWidget(
                      //       movie: movie,
                      //
                      //     )
                      // );
                    },
                  );
                },
              separatorBuilder: (context, index) => const SizedBox(height: 10,),
              itemCount: movies.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateMovieWidget(titleOnSubmit: (title), descriptionOnSubmit: (description) async {
              await movieDB.create(title: title, description: description, image: title);
              if (!mounted) return;
              fetchMovie();
              Navigator.of(context).pop();
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
