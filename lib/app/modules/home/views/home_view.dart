// ignore_for_file: unused_field, deprecated_member_use, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  final HomeController controller = Get.put(HomeController());

  final _formKey = GlobalKey<FormBuilderState>();

  // Function to check if the keyboard is visible
  bool isKeyboardVisible(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.viewInsets.bottom > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2857),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                formKey: _formKey,
                controller: controller,
              ),
              BannerCarousel(controller: controller),
              Categories(controller: controller),
              Canteens(controller: controller),
              FoodGrids(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key, required this.formKey, required this.controller});

  final HomeController controller;

  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 105,
          alignment: Alignment.centerLeft,
          color: Color(0xFF1E2857),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Antar ke :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 7),
                  SizedBox(
                    width: 175,
                    height: 25,
                    child: Obx(
                      () {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedLocation.value,
                              icon: Icon(
                                CupertinoIcons.chevron_down,
                                color: Colors.black,
                                size: 16,
                              ),
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              items: controller.buildings
                                  .map(
                                    (building) => DropdownMenuItem(
                                      value: building.name,
                                      child: Text(
                                        building.name,
                                        style: TextStyle(
                                          color: controller
                                                      .selectedLocation.value ==
                                                  building.name
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  controller.selectedLocation.value = newValue;
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: FormBuilder(
                    key: formKey,
                    child: FormBuilderTextField(
                      name: "search",
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          CupertinoIcons.search,
                          size: 18,
                          color: Colors.black87,
                        ),
                        hintText: "Cari Seleramu",
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 165,
            autoPlay: true,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            viewportFraction: 0.9,
            aspectRatio: 16 / 9,
            autoPlayInterval: Duration(seconds: 5),
            onPageChanged: (index, reason) {
              controller.updateIndex(index);
            },
          ),
          items: controller.bannerList.map((item) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF1E2857),
                  image: DecorationImage(
                    image: AssetImage(item),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.bannerList.asMap().entries.map((entry) {
              int index = entry.key;
              return Container(
                width: 15,
                height: 4,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 3,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: controller.currentIndex.value == index
                      ? Color(0xFF1E2857)
                      : Color(0xFF1E2857).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            'Kategori',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E2857),
            ),
          ),
        ),
        SizedBox(
          height: 85,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: controller.categories.map((category) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(category['image']!),
                      radius: 30,
                    ),
                    SizedBox(height: 5),
                    Text(
                      category['name']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E2857),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class Canteens extends StatelessWidget {
  const Canteens({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 25,
      ),
      child: SizedBox(
        height: 35,
        child: Obx(
          () => ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: controller.canteens.map((category) {
              bool isSelected =
                  controller.selectedCanteen.value == category['name'];

              return GestureDetector(
                onTap: () {
                  controller.selectCanteen(category['name']!);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: isSelected
                          ? Color(0xFF1E2857)
                          : Color(0xFF1E2857).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      category['name']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : Color(0xFF1E2857),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class FoodGrids extends StatelessWidget {
  const FoodGrids({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: SizedBox(
        height: (controller.foodItems.length / 2).ceil() * 200,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 0.87,
          ),
          itemCount: controller.foodItems.length,
          itemBuilder: (context, index) {
            final food = controller.foodItems[index];
            bool isClosed = food["status"] == "Tutup";

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: ColorFiltered(
                      colorFilter: isClosed
                          ? ColorFilter.mode(Colors.grey, BlendMode.saturation)
                          : ColorFilter.mode(
                              Colors.transparent, BlendMode.saturation),
                      child: Image.asset(
                        food["image"]!,
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              food["canteen"]!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              food["status"]!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isClosed ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          food["name"]!,
                          style: TextStyle(
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          food["price"]!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
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
