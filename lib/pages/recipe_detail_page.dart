// recipe_detail_page.dart
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  int _currentPage = 0;
  final List<String> imagesList = [
    'https://cdn.pixabay.com/photo/2020/11/01/23/22/breakfast-5705180_1280.jpg',
    'https://cdn.pixabay.com/photo/2016/11/18/19/00/breads-1836411_1280.jpg',
    'https://cdn.pixabay.com/photo/2019/01/14/17/25/gelato-3932596_1280.jpg',
    'https://cdn.pixabay.com/photo/2017/04/04/18/07/ice-cream-2202561_1280.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    void pageChaneg(int index) {
      setState(() {
        _currentPage = index;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Recipe Details')),
      body: SafeArea(
        child: Column(
          children: [
            Text('Recipe Name'),
            CarouselSlider(
                items: imagesList
                    .map((item) => Column(
                          children: [
                            Image.network(item,
                                fit: BoxFit.fill, width: double.infinity),
                                SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 30,
                                    ),
                                    onPressed: ()=>pageChaneg),
                                IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      size: 30,
                                    ),
                                    onPressed: () {}),
                              ],
                            ),
                          ],
                        ))
                    .toList(),
                options: CarouselOptions(
                  initialPage: _currentPage,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(
                      () {
                        _currentPage = index;
                      },
                    );
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 30,
                    ),
                    onPressed: () {}),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('List Ingredients'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Steps'),
            ),
          ],
        ),
      ),
    );
  }
}
