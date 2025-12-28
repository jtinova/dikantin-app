import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/home_courier_controller.dart';

class CourierOrderList extends GetView<HomeCourierController> {
  final List<dynamic> orders;
  final String emptyLottieAsset;
  final IconData fallbackEmptyIcon;
  final Function(Map<String, dynamic>) onItemTap;

  const CourierOrderList({
    super.key,
    required this.orders,
    required this.emptyLottieAsset,
    required this.fallbackEmptyIcon,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getPendingOrders();
        await controller.getProfile();
      },
      child: orders.isEmpty
          ? ListView(
              children: [
                SizedBox(height: 50.h),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        emptyLottieAsset,
                        width: 200.w,
                        height: 200.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            fallbackEmptyIcon,
                            size: 80.r,
                            color: Colors.grey,
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: orders.length,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 7.h),
                  child: ListTile(
                    onTap: () => onItemTap(order),
                    title: Text(
                      order['building_name'] ?? 'Lokasi tidak tersedia',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.formatCurrency(
                            (order['grand_total'] ?? 0).toDouble(),
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          order['destination_detail'] ??
                              'Detail lokasi tidak tersedia',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order['status']),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        _getStatusText(order['status']),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return const Color.fromARGB(255, 250, 191, 13);
      case 'delivered':
        return Colors.orange;
      case 'arrived':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Siap Antar';
      case 'delivered':
        return 'Sedang Diantar';
      case 'arrived':
        return 'Telah Tiba';
      case 'completed':
        return 'Selesai';
      default:
        return 'Unknown';
    }
  }
}
