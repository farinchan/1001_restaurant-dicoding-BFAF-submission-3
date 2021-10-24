import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_element.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';

class DetailScreen extends StatelessWidget {
  RestaurantElement resto;

  DetailScreen({Key? key, required this.resto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestaurantDetailProvider>(
        create: (_) =>
            RestaurantDetailProvider(apiService: ApiService(), id: resto.id),
        child: Consumer<RestaurantDetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.Error) {
              return Center(child: Text("failed get data"));
            } else if (state.result == ResultState.NoData) {
              return Center(child: Text(state.message));
            } else if (state.state == ResultState.HasData) {
              return NestedScrollView(
                  headerSliverBuilder: (context, isScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 200,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Image.network(
                            "https://restaurant-api.dicoding.dev/images/medium/" +
                                state.result.restaurant.pictureId,
                            fit: BoxFit.fitWidth,
                          ),
                          title: Text(state.result.restaurant.name,
                              style: TextStyle(shadows: [
                                BoxShadow(
                                    color: HomeColor,
                                    offset: Offset(2, 2),
                                    blurRadius: 5),
                              ])),
                        ),
                        backgroundColor: HomeColor,
                        leading: IconButton(
                            onPressed: () {
                              Navigation.back();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer<DatabaseProvider>(
                              builder: (context, provider, _) {
                                return FutureBuilder<bool>(
                                  future: provider.isFavorited(resto.id),
                                  builder: (context, snapshot) {
                                    var isBookmarked = snapshot.data ?? false;
                                    return Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: isBookmarked
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                color: HomeColor,
                                                size: 40,
                                              ),
                                              onPressed: () => provider
                                                  .removeBookmark(resto.id),
                                            )
                                          : IconButton(
                                              icon: Icon(
                                                Icons.favorite_outline_outlined,
                                                color: HomeColor,
                                                size: 40,
                                              ),
                                              onPressed: () =>
                                                  provider.addFavorite(resto),
                                            ),
                                    );
                                  },
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: HomeColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20))),
                              height: 60,
                              width: MediaQuery.of(context).size.width / 2 + 80,
                              padding: EdgeInsets.only(top: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.share_location,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        state.result.restaurant.city,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        state.result.restaurant.rating
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Category: ",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Row(
                                children: state.result.restaurant.categories
                                    .map((Category) => Container(
                                          color: HomeColor,
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            Category.name,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ))
                                    .toList(),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            state.result.restaurant.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Text(
                          "Daftar Menu",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Makanan :",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: state.result.restaurant.menus.foods
                                      .map((food) => Text(
                                            food.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Minuman :",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: state.result.restaurant.menus.drinks
                                      .map((drinks) => Text(
                                            drinks.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(bottom: 40, top: 20),
                          child: Column(
                            children: [
                              Text(
                                "Beri Rating Restaurant Ini",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 10),
                              Rating((rating) {})
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Penilaian Pelanggan",
                              style: TextStyle(fontSize: 25),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: state.result.restaurant.customerReviews
                                  .map((review) => ListTile(
                                        leading: Icon(
                                          Icons.person,
                                          size: 60,
                                        ),
                                        title: Text(review.name),
                                        subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('"${review.review}"'),
                                              Text("date: " + review.date),
                                            ]),
                                        isThreeLine: true,
                                      ))
                                  .toList(),
                            )
                          ],
                        )
                      ],
                    ),
                  ));
            } else {
              return Text("");
            }
          },
        ),
      ),
    );
  }
}

//RATING BAR
class Rating extends StatefulWidget {
  final int maxRating;
  final Function(int) onRatingSelected;
  Rating(this.onRatingSelected, [this.maxRating = 5]);
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int _currentRating = 0;

  Widget _buildRatingStar(int index) {
    if (index < _currentRating) {
      return Icon(
        Icons.star,
        color: Colors.orange,
        size: 40,
      );
    } else {
      return Icon(
        Icons.star_outline,
        size: 30,
      );
    }
  }

  Widget _buildBody() {
    final stars = List.generate(this.widget.maxRating, (index) {
      return GestureDetector(
        child: _buildRatingStar(index),
        onTap: () {
          setState(() {
            _currentRating = index + 1;
          });
        },
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
