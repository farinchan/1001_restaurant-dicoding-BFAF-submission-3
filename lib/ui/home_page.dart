import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/data/model/restaurant_element.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColor,
      appBar: AppBar(
        backgroundColor: HomeColor,
        elevation: 0,
        title: Text("1001 Restaurant"),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 200),
            height: 600,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "apa yang ingin kamu makan hari ini?",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  "ini rekomendasi restaurant buat kamu:",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child:
                    Consumer<RestaurantProvider>(builder: (context, state, _) {
                  if (state.state == ResultState.Loading) {
                    //loading widget
                    return Center(child: CircularProgressIndicator());
                  } else if (state.state == ResultState.Error) {
                    // error widget
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
                            style: TextStyle(fontSize: 16, color: HomeColor),
                          ),
                        ],
                      ),
                    );
                  } else if (state.state == ResultState.NoData) {
                    // error No Data
                    return Center(child: Text(state.message));
                  } else if (state.state == ResultState.HasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: state.result.count,
                        itemBuilder: (context, index) {
                          var resto = state.result.restaurants;
                          return buildRestoItem(resto[index], context);
                        });
                  } else {
                    return Text("");
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRestoItem(RestaurantElement resto, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
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
                        BorderSide(color: HomeColor),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  onPressed: () {
                    Navigation.intentWithData("/detail_screen", resto);
                    // Navigator.pushNamed(context, "/detail_screen",
                    //     arguments: resto.id);
                  },
                  child: Text(
                    "view",
                    style: TextStyle(color: HomeColor),
                  )))
        ],
      ),
    );
  }
}
