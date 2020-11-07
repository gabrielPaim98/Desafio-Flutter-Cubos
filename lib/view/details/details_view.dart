import 'package:desafiocubos/view/details/details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../consts/colors.dart';
import 'package:intl/intl.dart';

class DetailsView extends StatefulWidget {
  DetailsView({this.movieId, this.urlTest});

  final int movieId;
  final String urlTest;

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  Animation<double> controller;
  Animation<Offset> buttonTranslation;
  Animation<Offset> textTranslation;
  final currencyFormat = new NumberFormat('###,###,###');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller == null) {
      controller = ModalRoute.of(context).animation;

      textTranslation = Tween(
        begin: Offset(0.0, 10.0),
        end: Offset(0.0, 0.0),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(0.6, 0.8, curve: Curves.linear),
        ),
      );

      buttonTranslation = Tween(
        begin: Offset(-5.0, 0.0),
        end: Offset(0.0, 0.0),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(0.0, 0.6, curve: Curves.linear),
        ),
      );
    }
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
                          child: BackButton(
                            controller: controller,
                            textTranslation: textTranslation,
                            buttonTranslation: buttonTranslation,
                          ),
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
                        detailsVM.hasError
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ocorreu um erro ao carregar as informações do filme :(',
                                      style: TextStyle(
                                          fontSize: 18, color: KMediumGrey),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.03,
                                    ),
                                    InkWell(
                                      onTap: () =>
                                          detailsVM.onReloadButtonPressed(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: KDarkBlue,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Tentar novamente',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.03,
                                            ),
                                            Icon(
                                              Icons.refresh,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : detailsVM.isLoading
                                ? CircularProgressIndicator()
                                : Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            detailsVM.movieDetail.voteAverage,
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
                                        detailsVM.movieDetail.title
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: KDarkGrey),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Text(
                                        'Título original: ${detailsVM.movieDetail.originalTitle}',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InfoBox(
                                            leadingText: 'Ano:',
                                            text: detailsVM
                                                .movieDetail.releaseDate.year
                                                .toString(),
                                          ),
                                          InfoBox(
                                            leadingText: 'Duração:',
                                            text: detailsVM.duration,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Wrap(
                                        spacing: 16,
                                        runSpacing: 8,
                                        alignment: WrapAlignment.spaceEvenly,
                                        runAlignment: WrapAlignment.spaceEvenly,
                                        children: List.generate(
                                          detailsVM.movieDetail.genres.length,
                                          (index) => GenreBox(
                                              text: detailsVM.movieDetail
                                                  .genres[index].name),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.05,
                                      ),
                                      DescriptionText(
                                        title: 'Descrição',
                                        text: detailsVM.movieDetail.overview,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      Container(
                                        width: size.width,
                                        child: InfoBox(
                                          leadingText: 'ORÇAMENTO:',
                                          text:
                                              '\$ ${currencyFormat.format(detailsVM.movieDetail.budget)}',
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Container(
                                        width: size.width,
                                        child: InfoBox(
                                          leadingText: 'PRODUTORAS:',
                                          text: detailsVM.prodComp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      DescriptionText(
                                        title: 'Diretor',
                                        text: detailsVM.producers,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      DescriptionText(
                                        title: 'Elenco',
                                        text: detailsVM.cast,
                                      ),
                                    ],
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
          Flexible(
            child: Text(
              ' $text',
              style: TextStyle(
                color: KDarkGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  BackButton({this.textTranslation, this.controller, this.buttonTranslation});

  final Animation<Offset> textTranslation;
  final Animation<Offset> buttonTranslation;
  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return FractionalTranslation(
            translation: buttonTranslation.value,
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
                  FractionalTranslation(
                    translation: textTranslation.value,
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        fontSize: 16,
                        color: KDarkGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
