import 'package:desafiocubos/service/tmdb_api.dart';
import 'package:desafiocubos/view/details/details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../consts/colors.dart';

class DetailsView extends StatefulWidget {
  DetailsView({this.movieId, this.urlTest});

  final int movieId;
  final String urlTest;

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  void initState() {
    //TODO: chamar getMovieDetails
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Consumer<DetailsViewModel>(
          builder: (context, detailsVM, child) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height * 0.4,
                    color: KLightGrey,
                  ),
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: BackButton(),
                        ),
                        SizedBox(
                          height: size.height * 0.08,
                        ),
                        Container(
                          width: size.width * 0.65,
                          child: Hero(
                            tag: widget.movieId,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: widget.urlTest,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '7.3',
                              style: TextStyle(
                                color: KDarkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              ' /10',
                              style: TextStyle(
                                color: KMediumGrey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Text(
                          'Titulo do Filme'.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: KDarkGrey),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Text(
                          'Título original: Titulo do Filme',
                          style: TextStyle(
                            color: KMediumGrey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InfoBox(
                              leadingText: 'Ano:',
                              text: '2019',
                            ),
                            InfoBox(
                              leadingText: 'Duração:',
                              text: '1h 20 min',
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GenreBox(text: 'Ação'),
                            GenreBox(text: 'Aventura'),
                            GenreBox(text: 'SCI-FI'),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        DescriptionText(
                          title: 'Descrição',
                          text: _lorem,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          width: size.width,
                          child: InfoBox(
                            leadingText: 'ORÇAMENTO:',
                            text: '\$ 152,000,000',
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Container(
                          width: size.width,
                          child: InfoBox(
                            leadingText: 'PRODUTORAS:',
                            text: 'Marvel studios',
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        DescriptionText(
                          title: 'Diretor',
                          text: 'Ryan Fleck, Anna Boden',
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        DescriptionText(
                          title: 'Elenco',
                          text: 'Ryan Fleck, Anna Boden...',
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                      ],
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
}

class DescriptionText extends StatelessWidget {
  DescriptionText({this.title, this.text});

  final String title, text;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: KMediumGrey,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Text(
            text,
            style: TextStyle(
              color: KMediumGrey,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

class GenreBox extends StatelessWidget {
  GenreBox({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: KMediumGrey, width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: KMediumGrey,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  InfoBox({this.leadingText, this.text});

  final String leadingText, text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: KLightGrey,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            leadingText,
            style: TextStyle(
              color: KMediumGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' $text',
            style: TextStyle(
              color: KDarkGrey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.height * 0.03),
          boxShadow: [
            BoxShadow(
              color: KLightGrey,
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios,
              size: size.height * 0.02,
              color: KDarkGrey,
            ),
            SizedBox(
              width: size.width * 0.01,
            ),
            Text(
              'Voltar',
              style: TextStyle(
                fontSize: 16,
                color: KDarkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam efficitur gravida neque ut euismod. Cras maximus risus tincidunt ex vehicula, id dignissim eros vulputate. Sed ultrices sapien quis sagittis iaculis. Sed semper faucibus magna, et dapibus diam semper id. Vivamus mi est, semper quis erat ut, maximus cursus urna. Ut suscipit dignissim velit at cursus. Nulla sed cursus velit. Integer egestas venenatis sapien, id varius velit aliquam in. Fusce eu eros condimentum sem euismod auctor eget eu libero. Ut feugiat diam in nulla pharetra, id placerat sapien sodales.';
