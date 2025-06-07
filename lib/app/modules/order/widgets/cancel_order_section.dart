import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/order.dart';
import '../../../models/order_detail.dart';
import '../controllers/order_controller.dart';

class CancelOrder extends StatefulWidget {
  final OrderDetail order;
  final OrderController controller;

  const CancelOrder({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  State<CancelOrder> createState() => _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder> {
  late List<Order> cancelAbleItems;
  late List<Order> originalCancelAbleItems;

  @override
  void initState() {
    super.initState();
    cancelAbleItems =
        widget.order.details.where((item) => item.status == 'pending').toList();
    originalCancelAbleItems = List<Order>.from(cancelAbleItems);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        15.w,
        10.h,
        15.w,
        MediaQuery.of(context).viewInsets.bottom + 15.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              "Batalkan Pesanan",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          if (cancelAbleItems.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  "Tidak ada item.",
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cancelAbleItems.length,
                itemBuilder: (context, index) {
                  final item = cancelAbleItems[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 3.h),
                    child: ListTile(
                      leading: Icon(Icons.fastfood_outlined),
                      title: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jumlah : ${item.qty} x ${widget.controller.formatRupiah(item.sellingCost)}",
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                          ),
                          Text(
                            "Note : ${item.note ?? 'Tidak ada'}",
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                          )
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          CupertinoIcons.trash,
                          color: Colors.red,
                        ),
                        onPressed: () => _removeItem(item),
                      ),
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 15.h),
          SizedBox(
            width: double.infinity,
            height: 30.h,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2857),
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                "Tutup",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeItem(Order itemToRemove) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "Batalkan Pesanan",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Anda yakin menghapus ${itemToRemove.name} dari pesanan?",
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color(0xFF1E2857),
                ),
              ),
              child: Text(
                "Batal",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
            TextButton(
              child: Text(
                "Hapus",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                ),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await widget.controller.cancelOrder(itemToRemove.id);

                if (mounted) {
                  setState(() {
                    cancelAbleItems
                        .removeWhere((item) => item.id == itemToRemove.id);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
