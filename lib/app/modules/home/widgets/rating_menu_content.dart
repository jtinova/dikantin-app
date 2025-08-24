import 'package:dikantin_app_rebuild/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../models/menu_rating.dart';

class RatingMenu extends StatefulWidget {
  final String menuId;

  const RatingMenu({
    super.key,
    required this.menuId,
  });

  @override
  State<RatingMenu> createState() => _RatingMenuState();
}

class _RatingMenuState extends State<RatingMenu> {
  final HomeController _apiService = HomeController();
  late Future<Map<String, dynamic>> _ratingsFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    EasyLoading.show(status: 'Loading...');
    _ratingsFuture = _apiService.getRatingMenu(widget.menuId);
  }

  void _retry() {
    setState(() {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penilaian & Ulasan'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _ratingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            EasyLoading.dismiss();
          }

          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          }

          if (snapshot.hasData) {
            final dynamic data = snapshot.data!['data'];

            if (data is List && data.isEmpty) {
              return const Center(
                  child: Text('Belum ada ulasan untuk menu ini.'),);
            }

            if (data is Map<String, dynamic>) {
              final int ratingCount = data['rating_count'] ?? 0;

              if (ratingCount == 0) {
                return Center(
                  child: Text(
                    'Belum ada ulasan untuk menu ini',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              final double averageRating =
                  (data['average_rating'] as num?)?.toDouble() ?? 0.0;
              final List ratingsList = data['ratings'] ?? [];
              final List<MenuRating> ratings =
                  ratingsList.map((item) => MenuRating.fromJson(item)).toList();

              return Column(
                children: [
                  _buildSummaryHeader(averageRating, ratingCount),
                  const Divider(thickness: 1.3, color: Colors.black54),
                  Expanded(
                    child: ListView.separated(
                      itemCount: ratings.length,
                      itemBuilder: (context, index) =>
                          _buildReviewItem(ratings[index]),
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: const Divider(
                          thickness: 0.5,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: Text(
                'Terjadi kesalahan format data dari server.',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSummaryHeader(double averageRating, int ratingCount) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 5.h,
      ),
      child: Row(
        children: [
          Text(
            averageRating.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBarIndicator(
                rating: averageRating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 25.r,
              ),
              SizedBox(height: 4.h),
              Text(
                'Berdasarkan $ratingCount ulasan',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(MenuRating rating) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 5.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black12,
                child: Icon(
                  CupertinoIcons.person_fill,
                  size: 28.r,
                  color: Colors.black45,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.customerName,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy, HH:mm').format(
                        DateTime.parse(
                          rating.createdAt,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          RatingBarIndicator(
            rating: rating.rating.toDouble(),
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.r,
          ),
          if (rating.comment != null && rating.comment!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                rating.comment!,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.wifi_slash,
              color: Colors.black54,
              size: 60.r,
            ),
            SizedBox(height: 16.h),
            Text(
              'Gagal Memuat Ulasan',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString().replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E2857),
              ),
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: Text(
                'Coba Lagi',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
