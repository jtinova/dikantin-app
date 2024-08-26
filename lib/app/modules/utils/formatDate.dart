import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension IntExtensions on int {
  String toRupiah() {
    final formatCurrency = NumberFormat.currency(locale: "id-ID");
    String formattedCurrency = "Rp ${formatCurrency.format(this).substring(3)}";

    return formattedCurrency.substring(0, formattedCurrency.indexOf(','));
  }
}

String formatDateTime(String createdAt) {
  // Parse string ke DateTime
  DateTime dateTime = DateTime.parse(createdAt);

  // Definisikan format tanggal yang diinginkan
  DateFormat formatter = DateFormat('dd MMMM yyyy HH:mm:ss');

  // Format tanggal
  String formattedDate = formatter.format(dateTime);

  return formattedDate;
}