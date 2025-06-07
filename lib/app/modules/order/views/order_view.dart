import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';
import '../widgets/order_content_section.dart';
import '../widgets/order_filter_section.dart';
import '../widgets/order_tab_section.dart';

class OrderView extends GetView<OrderController> {
  OrderView({super.key});

  @override
  final OrderController controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Pesanan',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshAll();
          },
          child: LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    OrderTabs(controller: controller),
                    SizedBox(height: 10.h),
                    OrderFilters(controller: controller),
                    SizedBox(height: 5.h),
                    Expanded(
                      child: OrderContent(controller: controller),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}