import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/home_courier_controller.dart';

class CourierDetailSheet extends StatelessWidget {
  final Map<String, dynamic> order;
  final Map<String, dynamic> details;
  final List<dynamic> orderItems;
  final HomeCourierController controller;
  final Function(List<dynamic>) onShowItems;

  const CourierDetailSheet({
    super.key,
    required this.order,
    required this.details,
    required this.orderItems,
    required this.controller,
    required this.onShowItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Pesanan',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          if (details.isNotEmpty &&
              details['customer_information'] != null) ...[
            DetailRow(
              title: 'Pelanggan',
              value: details['customer_information']['full_name'] ?? '-',
            ),
            DetailRow(
              title: 'No. Telepon',
              value: details['customer_information']['phone_number'] ?? '-',
            ),
            DetailRow(
              title: 'Lokasi',
              value:
                  '${details['customer_information']['building_name'] ?? '-'}\n${details['customer_information']['destination_detail'] ?? '-'}',
            ),
          ],
          if (details.isNotEmpty && details['transaction_summary'] != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total Item',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${details['transaction_summary']['total_qty'] ?? 0} items',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (orderItems.isNotEmpty)
                        InkWell(
                          onTap: () => onShowItems(orderItems),
                          child: Icon(
                            CupertinoIcons.info_circle,
                            size: 18.r,
                            color: const Color(0xFF1E2857),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            DetailRow(
              title: 'Total Harga',
              value: controller.formatCurrency(
                  (details['transaction_summary']['total_selling_cost'] ?? 0)
                      .toDouble()),
            ),
            DetailRow(
              title: 'Biaya Antar',
              value: controller.formatCurrency(
                  (details['transaction_summary']['delivery_fee'] ?? 0)
                      .toDouble()),
            ),
            DetailRow(
              title: 'Total Pembayaran',
              value: controller.formatCurrency(
                  (details['transaction_summary']['grand_total'] ?? 0)
                      .toDouble()),
            ),
            DetailRow(
              title: 'Metode Pembayaran',
              value: controller.capitalizeFirst(
                  details['transaction_summary']['payment_method'] ?? '-'),
            ),
          ],
          SizedBox(height: 20.h),
          if (order['status'] == 'pending') ...{
            ElevatedButton(
              onPressed: () {
                controller.startOrderToDelivered(order['id'].toString());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2857),
                minimumSize: Size(double.infinity, 45.h),
              ),
              child: Text(
                'Mulai Antar',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          } else if (order['status'] == 'delivered') ...{
            ElevatedButton(
              onPressed: () {
                controller.markOrderAsArrived(order['id'].toString());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 45.h),
              ),
              child: Text(
                'Sampai Tujuan',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          } else if (order['status'] == 'arrived') ...{
            ElevatedButton(
              onPressed: () {
                controller.completeOrder();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 45.h),
              ),
              child: Text(
                'Scan QrCode Pelanggan',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          },
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
