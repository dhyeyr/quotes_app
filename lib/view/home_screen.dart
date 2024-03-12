import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_page_contoller.dart';
import '../controller/random_quote_controller.dart';
import '../controller/second_page_controller.dart';
import '../modal/db_helper.dart';
import '../modal/quote_model.dart';

class Quote_Home extends StatefulWidget {
  const Quote_Home({super.key});

  @override
  State<Quote_Home> createState() => _Quote_HomeState();
}

RandomQuoteController randomQuoteController = Get.put(RandomQuoteController());
HomeController homeController = Get.put(HomeController());
SecondPageController secondPageController = Get.put(SecondPageController());

class _Quote_HomeState extends State<Quote_Home> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Quotes",
              textAlign: TextAlign.center, style: GoogleFonts.alkalami()),
          centerTitle: true,
          leading:
              IconButton(onPressed: () {}, icon: Icon(Icons.menu_outlined)),
          actions: [
            IconButton(
                onPressed: () {
                  homeController.goToFavoritePage();
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 10,top: 10),
              child: Text("Random Quote",
                  style: GoogleFonts.alkalami(fontSize: 20)),
            ),
            InkWell(
              onTap: () {
                randomQuoteController.getApiData();
              },
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    height: MediaQuery.of(context).size.height / 5,
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: randomQuoteController.random.length,
                      itemBuilder: (BuildContext context, int index) {
                        var sample = randomQuoteController.random[index];
                        randomQuoteController.quote.value = "${sample.content}";
                        randomQuoteController.cIndex = index;
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Obx(() => Column(
                              children: [
                                Text(
                                      "${randomQuoteController.quote.value}",
                                  style: GoogleFonts.abyssinicaSil(fontSize: 15),
                                    ),
                                Text(
                                  " \n                                                        - ${randomQuoteController.author.value}",
                                  style: GoogleFonts.alkalami(),
                                ),
                              ],
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 307, top: 115),
                    child: IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () async {
                        var sample = randomQuoteController
                            .random[randomQuoteController.cIndex];
                        DbHelper.instance.insertData("${sample.content}");
                        addToFavorites("${sample.content}");
                      },
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,top: 10),
              child:Text("Categories",
                  style: GoogleFonts.alkalami(fontSize: 20)),
            ),
            Expanded(
              child: Obx(
                () => GridView.builder(
                  clipBehavior: Clip.antiAlias,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: width / (height / 2.0),
                      crossAxisCount: 2),
                  itemCount: homeController.allQuote.value.length,
                  itemBuilder: (context, index) {
                    if (index < homeController.bgImages.length) {
                      return InkWell(
                        onTap: () {
                          secondPageController.sel_index.value = index;
                          secondPageController.currentCategory.value =
                              homeController.categories[
                                  secondPageController.sel_index.value];
                          homeController.goToSecondPage();
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(homeController.bgImages[index]),
                              fit: BoxFit.fill,
                            ),
                            color: Colors.blueGrey,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }

  List<String> getAllCategories(List<QuoteModel> allQuote) {
    Set<String> categoriesSet = <String>{};
    for (var quoteModel in allQuote) {
      categoriesSet.addAll(quoteModel.categories ?? []);
    }
    return categoriesSet.toList();
  }

  List<String> getAllBackgroundImages(List<QuoteModel> allQuote) {
    List<String> backgroundImages = [];
    for (var quoteModel in allQuote) {
      backgroundImages.addAll(quoteModel.bgImages ?? []);
    }
    return backgroundImages;
  }

  void addToFavorites(String quote) async {
    bool added = await DbHelper.instance.insertData(quote);
    if (added) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quote added to favorites'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quote is already in favorites'),
        ),
      );
    }
  }
}
