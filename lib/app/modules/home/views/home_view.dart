// ignore_for_file: unused_field, deprecated_member_use, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:badges/badges.dart' as badges;

import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../models/menu.dart';
import '../../../routes/app_pages.dart';
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
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshAll();
          },
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
          height: 107,
          alignment: Alignment.centerLeft,
          color: Color(0xFF1E2857),
        ),
        Row(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: IconButton(
                onPressed: () {
                  Get.to(Routes.CART);
                },
                icon: Obx(() => badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -10, end: -10),
                      badgeStyle:
                          const badges.BadgeStyle(badgeColor: Colors.white),
                      badgeAnimation: badges.BadgeAnimation.rotation(),
                      badgeContent: Text(
                        "${controller.cartCount}",
                        style: TextStyle(
                          color: Color(0xFF1E2857),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Icon(
                        CupertinoIcons.cart_fill,
                        color: Colors.white,
                        size: 27,
                      ),
                    )),
              ),
            ),
          ],
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
                        if (controller.isLoading.value) {
                          return Skeletonizer(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }

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
                      onChanged: (value) {
                        if (value!.isNotEmpty) {
                          controller.getSearchMenu(query: value);
                        }
                      },
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
        Obx(() {
          if (controller.isLoading.value) {
            return Skeletonizer(
              enabled: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: double.infinity,
                  height: 165,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            );
          }

          return CarouselSlider(
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
          );
        }),
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
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Skeletonizer(
                enabled: true,
                child: Container(
                  height: 15,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            }

            return Text(
              'Kategori',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2857),
              ),
            );
          }),
        ),
        SizedBox(
          height: 85,
          child: Obx(() {
            if (controller.isLoading.value) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Skeletonizer(
                      enabled: true,
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 80,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: controller.categories.map((category) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () {
                      // Fetch menu by category
                      controller.getMenuByCategory(id: category.id);

                      // Highlight this category
                      controller.selectedCategoryId.value = category.id;

                      // Reset canteen to "Semua"
                      controller.selectedCanteenId.value = "all";
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/image_carousel.png'),
                          radius: 30,
                        ),
                        SizedBox(height: 5),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: controller.selectedCategoryId.value ==
                                    category.id
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: Color(0xFF1E2857),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
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
        vertical: 20,
      ),
      child: SizedBox(
        height: 35,
        child: Obx(() {
          if (controller.isLoading.value) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: controller.canteens.map((canteen) {
              bool isSelected =
                  controller.selectedCanteenId.value == canteen.id;

              return GestureDetector(
                onTap: () {
                  // Fetch menu by canteen
                  controller.getMenuByCanteen(id: canteen.id, context: context);

                  // Highlight this canteen
                  controller.selectedCanteenId.value = canteen.id;

                  // Reset category selection
                  controller.selectedCategoryId.value = "";
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
                      canteen.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : Color(0xFF1E2857),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
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
      child: Obx(() {
        if (controller.isLoading.value) {
          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.87,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Skeletonizer(
                enabled: true,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 15,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 15,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (controller.menus.isEmpty) {
          return Center(
            child: Text(
              "Tidak ada menu tersedia",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return SizedBox(
          height: (controller.menus.length / 2).ceil() * 198,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.87,
            ),
            itemCount: controller.menus.length,
            itemBuilder: (context, index) {
              final food = controller.menus[index];
              bool isClosed = food.canteen.status == "close";

              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    builder: (context) {
                      return MenuDetailBottom(
                        food: food,
                        controller: controller,
                      );
                    },
                  );
                },
                child: Card(
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
                              ? ColorFilter.mode(
                                  Colors.grey, BlendMode.saturation)
                              : ColorFilter.mode(
                                  Colors.transparent, BlendMode.saturation),
                          child: Image.asset(
                            'assets/images/image_carousel.png',
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
                                  food.canteen.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  controller
                                      .capitalizeFirst(food.canteen.status),
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
                              food.name,
                              style: TextStyle(
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rp ${controller.formatRupiah(food.sellingCost)}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Obx(() {
                                  int quantity = controller.getQuantity(food);
                                  return quantity > 0
                                      ? Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controller.updateCart(
                                                  food,
                                                  isAdding: false,
                                                );
                                              },
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              "$quantity",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            GestureDetector(
                                              onTap: () {
                                                controller.updateCart(
                                                  food,
                                                  isAdding: true,
                                                );
                                              },
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF1E2857),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (!isClosed) {
                                              controller.addToCart(food, 1);
                                            } else {
                                              Get.snackbar(
                                                "Kantin Tutup",
                                                "Tidak dapat menambahkan menu ke keranjang",
                                                animationDuration:
                                                    Duration(milliseconds: 200),
                                                duration: Duration(
                                                    milliseconds: 1650),
                                                backgroundColor: Colors.red,
                                                borderWidth: 5.0,
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                colorText: Colors.white,
                                                margin: EdgeInsets.all(20.0),
                                                icon: Icon(
                                                  CupertinoIcons.info_circle,
                                                  color: Colors.white,
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF1E2857),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class MenuDetailBottom extends StatelessWidget {
  const MenuDetailBottom(
      {super.key, required this.food, required this.controller});

  final Menu food;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    bool isClosed = food.canteen.status == "close";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              food.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2857),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/images/image_carousel.png',
              width: double.infinity,
              height: 150,
            ),
          ),
          SizedBox(height: 10),
          Text(
            food.description,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF1E2857),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Kantin: ",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2857),
                ),
              ),
              Text(
                controller.capitalizeFirst(food.canteen.status),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: isClosed ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                "Harga: Rp ${food.sellingCost}",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2857),
                ),
              ),
              Spacer(),
              Obx(() {
                int quantity = controller.getQuantity(food);
                return quantity > 0
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.updateCart(
                                food,
                                isAdding: false,
                              );
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "$quantity",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              controller.updateCart(
                                food,
                                isAdding: true,
                              );
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFF1E2857),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          if (!isClosed) {
                            controller.addToCart(food, 1);
                          } else {
                            Get.snackbar(
                              "Kantin Tutup",
                              "Tidak dapat menambahkan menu ke keranjang",
                              animationDuration: Duration(milliseconds: 200),
                              duration: Duration(milliseconds: 1650),
                              backgroundColor: Colors.red,
                              borderWidth: 5.0,
                              snackPosition: SnackPosition.TOP,
                              colorText: Colors.white,
                              margin: EdgeInsets.all(20.0),
                              icon: Icon(
                                CupertinoIcons.info_circle,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFF1E2857),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      );
              }),
              SizedBox(height: 20),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E2857),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: Text("Tutup", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
