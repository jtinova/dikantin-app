import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../order/controllers/order_controller.dart';

class RatingMenu extends StatefulWidget {
  final String transactionDetailId;
  final String menuId;
  final String menuName;
  final bool isReadOnly;
  final bool isUpdate;
  final String orderDate;
  final double initialRating;
  final String initialComment;

  const RatingMenu({
    super.key,
    required this.transactionDetailId,
    required this.menuId,
    required this.menuName,
    required this.isReadOnly,
    required this.isUpdate,
    required this.orderDate,
    this.initialRating = 0,
    this.initialComment = '',
  });

  @override
  State<RatingMenu> createState() => _RatingMenuState();
}

class _RatingMenuState extends State<RatingMenu> {
  final OrderController orderController = Get.find();
  final _formKey = GlobalKey<FormBuilderState>();
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.isReadOnly
              ? "Lihat Penilaian"
              : (widget.isUpdate ? "Ubah Penilaian" : "Beri Penilaian"),
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.menuName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Dinilai dari pesanan pada ${orderController.formatDateTime(widget.orderDate)}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black54,
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 15.h,
                        color: Colors.black45,
                      ),
                      Text(
                        'Berikan Penilaian',
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        ignoreGestures: widget.isReadOnly,
                        onRatingUpdate: (rating) {
                          if (!widget.isReadOnly) {
                            setState(() {
                              _rating = rating;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        widget.isReadOnly
                            ? 'Ulasan Anda'
                            : 'Tulis ulasan (Opsional)',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      FormBuilderTextField(
                        name: 'comment',
                        initialValue: widget.initialComment,
                        readOnly: widget.isReadOnly,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        maxLines: 4,
                      ),
                      SizedBox(height: 25.h),
                      SizedBox(
                        width: double.infinity,
                        height: 45.h,
                        child: ElevatedButton(
                          onPressed: widget.isReadOnly
                              ? null
                              : _rating > 0
                                  ? () {
                                      _formKey.currentState?.save();
                                      final String? comment = _formKey
                                          .currentState?.value['comment'];

                                      orderController.addRating(
                                        transactionDetailId:
                                            widget.transactionDetailId,
                                        rating: _rating.toInt(),
                                        comment: comment,
                                      );
                                    }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E2857),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: Text(
                            widget.isReadOnly
                                ? 'Penilaian Terkirim'
                                : (widget.isUpdate
                                    ? 'Simpan Perubahan'
                                    : 'Kirim Penilaian'),
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
