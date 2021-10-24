import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/common/style.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FavoriteColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite),
            SizedBox(width: 10),
            Text("Favorite")
          ],
        ),
        elevation: 0,
        backgroundColor: FavoriteColor,
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.only(top: 20),
        height: 1000,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: Consumer<DatabaseProvider>(
          builder: (context, provider, child) {
            if (provider.state == ResultState.Error) {
              return Center(
                child: Text(
                  provider.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: FavoriteColor, fontSize: 16),
                ),
              );
            } else if (provider.state == ResultState.NoData) {
              return Center(
                child: Text(
                  provider.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: FavoriteColor, fontSize: 16),
                ),
              );
            } else if (provider.state == ResultState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (provider.state == ResultState.HasData) {
              return ListView.builder(
                itemCount: provider.favorite.length,
                itemBuilder: (context, index) {
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
                                    provider.favorite[index].pictureId,
                                width: 100,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.favorite[index].name,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.share_location,
                                            color: Colors.redAccent[100],
                                            size: 20,
                                          ),
                                          Text(provider.favorite[index].city),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 20,
                                          ),
                                          Text(provider.favorite[index].rating
                                              .toString())
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
                                      BorderSide(color: FavoriteColor),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    )),
                                onPressed: () {
                                  Navigation.intentWithData(
                                    "/detail_screen",
                                    provider.favorite[index],
                                  );
                                  // Navigator.pushNamed(context, "/detail_screen",
                                  //     arguments: resto.id);
                                },
                                child: Text(
                                  "view",
                                  style: TextStyle(color: FavoriteColor),
                                )))
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text(""));
            }
          },
        ),
      ),
    );
  }
}
