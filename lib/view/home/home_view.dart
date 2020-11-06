import 'package:flutter/material.dart';
import '../../consts/colors.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
              margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: 5 + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == 0)
                        return SizedBox(
                          height: size.height * 0.08,
                        );
                      return MovieContainer(title: 'Capitã Marvel', gender: 'Ação - Aventura',);
                    },
                  ),
                  Container(
                    // Blur effect
                    height: size.height * 0.16,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0.001)],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                    child: ListView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        return CategoryFilter(
                          title: 'Ação',
                          isSelected: index == 0,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryFilter extends StatefulWidget {
  CategoryFilter({@required this.title, this.isSelected = false});

  final String title;
  bool isSelected;

  @override
  _CategoryFilterState createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSelected ? KDarkBlue : Colors.white,
          borderRadius: BorderRadius.circular(size.height * 0.03),
          border: Border.all(color: KDarkBlue, width: 0.1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 14,
              color: widget.isSelected ? Colors.white : KDarkBlue,
            ),
          ),
        ),
      ),
    );
  }
}

class MovieContainer extends StatelessWidget {
  MovieContainer({
    @required this.title,
    @required this.gender,
  });

  final String title;
  final String gender;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                title.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Text(
              gender,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
