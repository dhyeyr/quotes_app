// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes_app/controller/second_page_controller.dart';

import '../controller/home_page_contoller.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

HomeController homeController = Get.find<HomeController>();
SecondPageController secondPageController = Get.find<SecondPageController>();

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title:  Text(secondPageController.currentCategory.value,
            style: GoogleFonts.alkalami(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            secondPageController.goToHomePage();
          },
          icon: Icon(
            Icons.home,
            color: Colors.black,
          ),
        ),
        actions: [

          IconButton(
              onPressed: () {
                secondPageController.goToFavoritePage();
              },
              icon: Icon(
                Icons.favorite_border,
                color: Colors.black,
              ))
        ],
      ),
      body: SizedBox(
        height: 700,
        child: Obx(
          () => ListView.builder(
            itemCount: secondPageController
                .getQuote(secondPageController.currentCategory.value)
                .length,
            itemBuilder: (context, index) {
              var quote = secondPageController.getQuote(
                  secondPageController.currentCategory.value)[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // qt_index = index;
                    // Navigator.pushNamed(context, detail_page,
                    //     arguments: [quote ?? "", bgImages[sel_index] ?? ""]);
                    print("QUOTE ==> ${quote}");
                    secondPageController.goToDetailPage(
                        quote ?? "",
                        secondPageController.bgImages[
                            secondPageController.sel_index.value]);
                    print("CLICKED ==>");
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5,right: 5),
                    clipBehavior: Clip.antiAlias,
                    // height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(quote,
                            style:
                                TextStyle(color: Colors.black, fontSize: 18)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
