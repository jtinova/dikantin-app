// lib/app/modules/profile/widgets/favorite_menu_section.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dikantin_app_rebuild/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../home/widgets/canteen_detail_menu.dart';

class FavoriteMenu extends StatefulWidget {
  const FavoriteMenu({super.key});

  @override
  State<FavoriteMenu> createState() => _FavoriteMenuState();
}

class _FavoriteMenuState extends State<FavoriteMenu> {
  final HomeController controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.getFavoriteMenuForProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Menu Favorit',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 25.r,
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.isMenuLoading.value) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (controller.favoriteMenus.isEmpty) {
            return Center(
              child: Text(
                'Belum Ada Menu Favorit',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.getFavoriteMenuForProfile(),
            child: ListView.separated(
              padding: EdgeInsets.all(10.r),
              itemCount: controller.favoriteMenus.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.black26,
                thickness: 1,
                height: 5.h,
              ),
              itemBuilder: (context, index) {
                final menu = controller.favoriteMenus[index];
                bool isClosed = menu.canteen.status == 'close';
                bool isOutOfStock = menu.stock <= 0;
                bool isUnavailable = isClosed || isOutOfStock;

                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15.r),
                        ),
                      ),
                      builder: (context) {
                        return MenuDetailBottom(
                          food: menu,
                          controller: controller,
                        );
                      },
                    );
                  },
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              isUnavailable ? Colors.grey : Colors.transparent,
                              BlendMode.saturation,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: menu.imageUrl,
                              width: 90.w,
                              height: 90.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/logo_dikantin.png',
                                width: 90.w,
                                height: 90.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  menu.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text(
                                      menu.canteen.name,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.circle_fill,
                                        size: 4.r,
                                      ),
                                    ),
                                    Text(
                                      isClosed ? 'Tutup' : 'Buka',
                                      style: TextStyle(
                                        color: isClosed
                                            ? Colors.red
                                            : Colors.green,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 15.r,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      menu.rating!.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Rp ${controller.formatRupiah(menu.sellingCost)}",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () {
                            final isFavorited =
                                controller.favoriteMenuId.contains(menu.id);

                            return GestureDetector(
                              onTap: () =>
                                  controller.toggleFavoriteStatus(menu),
                              child: Container(
                                padding: EdgeInsets.all(20.r),
                                child: Icon(
                                  isFavorited
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: isFavorited
                                      ? Colors.redAccent
                                      : Colors.grey,
                                  size: 30.r,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
