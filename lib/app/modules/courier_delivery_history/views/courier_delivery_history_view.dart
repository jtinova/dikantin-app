import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/courier_delivery_history_controller.dart';

class CourierDeliveryHistoryView extends GetView<CourierDeliveryHistoryController> {
  const CourierDeliveryHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pengantaran'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : controller.deliveryHistory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada riwayat pengantaran',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.deliveryHistory.length,
                    itemBuilder: (context, index) {
                      final delivery = controller.deliveryHistory[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ListTile(
                          title: Text(
                            delivery['building_name'] ?? 'Lokasi tidak tersedia',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.formatCurrency(
                                    (delivery['delivery_fee'] ?? 0).toDouble()),
                              ),
                              Text(
                                delivery['destination_detail'] ?? 'Detail lokasi tidak tersedia',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Tanggal: ${delivery['arrival_date'] ?? '-'}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Selesai',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
} 