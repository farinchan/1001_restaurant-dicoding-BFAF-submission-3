import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/data/model/restaurant_element.dart';
import 'package:restaurant_app/data/model/restaurant_search.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String queries = '';
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: SearchColor,
          title: Text(
            "Pencarian",
            style: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.white, displayColor: Colors.white)
                .headline5,
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Consumer<SearchRestaurantProvider>(
                builder: (context, state, _) {
                  return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: ListTile(
                          leading: Icon(
                            Icons.search,
                            size: 30,
                            color: SearchColor,
                          ),
                          title: TextField(
                            controller: _controller,
                            onChanged: (String value) {
                              setState(() {
                                queries = value;
                              });
                              if (value != '') {
                                state.fetchAllRestaurantSearch(value);
                              }
                            },
                            cursorColor: SearchColor,
                            decoration: InputDecoration(
                                hintText: "Cari Restoran",
                                border: InputBorder.none),
                          ),
                          trailing: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              if (queries != '') {
                                _controller.clear();
                                setState(() {
                                  queries = '';
                                });
                              }
                            },
                            icon: Icon(Icons.cancel_outlined, size: 30),
                          )));
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: _listSearchRestaurants(context),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _listSearchRestaurants(BuildContext context) {
    return Consumer<SearchRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == StateResultSearch.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == StateResultSearch.HasData) {
          return Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.result!.restaurants.length,
                itemBuilder: (context, index) {
                  var resto = state.result!.restaurants;
                  return buildRestoItem(resto[index], index, context);
                },
              ));
        } else if (state.state == StateResultSearch.NoData) {
          return Center(
              child: Text(
            state.message,
            style: TextStyle(color: SearchColor),
          ));
        } else if (state.state == StateResultSearch.Error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/connection.png",
                  width: 50,
                ),
                Text(
                  " Gagal Memuat Data\nHarap Periksa Koneksi Internet kamu",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: SearchColor),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }
}

Widget buildRestoItem(
    RestaurantElement resto, int index, BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(2, 1),
            blurRadius: 10,
          ),
        ]),
    child: Stack(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://restaurant-api.dicoding.dev/images/medium/" +
                    resto.pictureId,
                width: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resto.name,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.share_location,
                            color: Colors.redAccent[100],
                            size: 20,
                          ),
                          Text(resto.city),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          Text(resto.rating.toString())
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
            bottom: 3,
            right: 20,
            child: OutlinedButton(
                style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(color: SearchColor),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    )),
                onPressed: () {
                  Navigator.pushNamed(context, "/detail_screen",
                      arguments: resto);
                },
                child: Text(
                  "view",
                  style: TextStyle(color: SearchColor),
                )))
      ],
    ),
  );
}
