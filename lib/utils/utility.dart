// ignore_for_file: use_build_context_synchronously

import 'package:demo/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Utility {
  static Future<bool> isNetworkAvailable() async {
    // Add your implementation for network check
    return true;
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeText(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: AppColors.primaryWhite,
            ),
            child: const CupertinoActivityIndicator(
              color: AppColors.secondaryBackground,
              // size: 100.sp,
            ),
          ),
        );
      },
    );
  }

  static void closeLoader(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  static String getLimitedText(String text, int limit) {
    return text.length > limit ? "${text.substring(0, limit)}..." : text;
  }
}

enum MessageType { error, success, information }

class Validators {
  String? validateEmail(String? p0) {
    if (p0 == null || p0.isEmpty) {
      return "Email is required";
    }

    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(p0)) {
      return "Enter a valid email (e.g., user@example.com)";
    }

    return null;
  }

  String? validateText(String? p0, String fieldName) {
    if (p0!.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  String? validatePhone(String? p0) {
    if (p0 == null || p0.isEmpty) {
      return "Phone number is required";
    }

    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');

    if (!phoneRegex.hasMatch(p0)) {
      return "Enter a valid 10-digit phone number";
    }

    return null;
  }

  String? validateDomainName(String? p0) {
    if (p0 == null || p0.isEmpty) {
      return "Company domain is required";
    }

    final RegExp domainRegex = RegExp(
      r'^(?!-)[A-Za-z0-9-]{1,63}(?<!-)(\.[A-Za-z]{2,6})+$',
    );

    if (!domainRegex.hasMatch(p0)) {
      return "Enter a valid domain (e.g., example.com)";
    }

    return null;
  }

  String? validateInteger(String? p0, String fieldName) {
    if (p0 == null || p0.isEmpty) {
      return "$fieldName is required";
    }

    if (int.tryParse(p0) == null) {
      return "$fieldName must be an integer";
    }

    return null;
  }

  String? validatePostal(String? p0) {
    if (p0 == null || p0.isEmpty) {
      return "Postal code is required";
    }

    final RegExp postalCodeRegex = RegExp(r'^[0-9]{6}$');

    if (!postalCodeRegex.hasMatch(p0)) {
      return "Enter a valid 6-digit postal code";
    }

    return null;
  }

  String? validateTimezone(String? p0) {
    String timeZone = p0!.trim();
    if (timeZone.isEmpty) {
      return "Field is required";
    }
    if (!RegExp(r'^[A-Za-z]+\/[A-Za-z_]+(?:\/[A-Za-z_]+)*$')
        .hasMatch(timeZone)) {
      return "Enter a valid timezone (e.g., America/New_York)";
    }
    return null;
  }

  String? validateLinkedIn(String? p0) {
    if (p0 == null || p0.isEmpty) {
      return "LinkedIn company page link is required";
    }

    final RegExp linkedInRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?linkedin\.com\/company\/[a-zA-Z0-9-]+\/?$',
    );

    if (!linkedInRegex.hasMatch(p0)) {
      return "Enter a valid LinkedIn page URL (e.g., https://www.linkedin.com/company/example)";
    }

    return null;
  }

  String? validateDouble(String? p0, String field) {
    if (p0 == null || p0.isEmpty) {
      return "$field is required";
    }

    if (double.tryParse(p0) == null) {
      return "Enter a valid value";
    }

    return null;
  }

  String? validateUrl(String? p0) {
    if (p0 == null || p0.isEmpty) {
      return "URL is required";
    }

    final RegExp urlRegex = RegExp(
      r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/.*)?$',
    );

    if (!urlRegex.hasMatch(p0)) {
      return "Enter a valid URL (e.g., https://example.com)";
    }

    return null;
  }
}
