import 'package:desafiocubos/model/movie.dart';
import 'package:desafiocubos/model/movie_details.dart';
import 'package:desafiocubos/service/tmdb_api.dart';
import 'package:desafiocubos/view/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../consts/colors.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    context.read<HomeViewModel>().initCalls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, homeModel, child) {
            if (homeModel.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Filmes',
                      style: TextStyle(
                        color: KDarkGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: KLightGrey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: 24,
                          color: Colors.grey.shade600,
                        ),
                        hintText: 'Pesquise Filmes',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => homeModel.onSearchChanged(value),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          controller: homeModel.scrollController,
                          itemCount: homeModel.movieContainers.length + 2,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == 0)
                              return SizedBox(
                                height: size.height * 0.08,
                              );
                            else if (index ==
                                homeModel.movieContainers.length + 1)
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            else
                              return homeModel.movieContainers[index - 1];
                          },
                        ),
                        Container(
                          // Blur effect
                          height: size.height * 0.16,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.001)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.06,
                          child: ListView.builder(
                            itemCount: homeModel.genres.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              return CategoryFilter(
                                genre: homeModel.genres[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
          },
        ),
      ),
    );
  }
}

class CategoryFilter extends StatefulWidget {
  CategoryFilter({
    @required this.genre
  });
  final Genre genre;

  @override
  _CategoryFilterState createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HomeViewModel>(
      builder: (context, homeModel, child) {
        return GestureDetector(
          onTap: () async {
            setState(() {
              isSelected = !isSelected;
            });
            await homeModel.onGenreFilterPressed(widget.genre);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? KDarkBlue : Colors.white,
              borderRadius: BorderRadius.circular(size.height * 0.03),
              border: Border.all(color: KDarkBlue, width: 0.1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            margin: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
            child: Center(
              child: Text(
                widget.genre.name,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.white : KDarkBlue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MovieContainer extends StatelessWidget {
  MovieContainer({
    @required this.movie,
    @required this.genres,
  });

  final Movie movie;
  final String genres;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => context.read<HomeViewModel>().onMoviePressed(context, movie.id, '${TmdbConsts.imagePath}${movie.posterPath}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          child: Stack(
            children: [
              Hero(
                tag: movie.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: '${TmdbConsts.imagePath}${movie.posterPath}',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.01), Colors.black],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          movie.title.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        genres,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
