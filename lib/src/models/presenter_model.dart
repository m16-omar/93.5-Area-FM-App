import 'package:flutter/material.dart';

class PresenterModel {
  final String id;
  final String name;
  final String showName;
  final String timeSlot;
  final String days;
  final String category;
  final bool isOnAir;
  final String image;
  final String tagline;
  final String about;
  final String bio;
  final String birthday;
  final String onAirSince;
  final String location;
  final String instagram;
  final String twitter;
  final String facebook;
  final String tiktok;
  final List<Color> gradientColors;
  final Color accentColor;

  const PresenterModel({
    required this.id,
    required this.name,
    required this.showName,
    this.timeSlot = '',
    this.days = 'Weekdays',
    this.category = 'Presenters',
    this.isOnAir = false,
    required this.image,
    this.tagline = '',
    this.about = '',
    required this.bio,
    this.birthday = 'May 20',
    this.onAirSince = '2016',
    this.location = 'Lagos, Nigeria',
    this.instagram = '',
    this.twitter = '',
    this.facebook = '',
    this.tiktok = '',
    this.gradientColors = const [Color(0xFF0F3E9B), Color(0xFF061840)],
    this.accentColor = const Color(0xFFFF5500),
  });

  factory PresenterModel.fromJson(Map<String, dynamic> json) {
    return PresenterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      showName: json['showName'] ?? '',
      timeSlot: json['timeSlot'] ?? '',
      days: json['days'] ?? 'Weekdays',
      category: json['category'] ?? 'Presenters',
      isOnAir: json['isOnAir'] ?? false,
      image: json['image'] ?? '',
      tagline: json['tagline'] ?? '',
      about: json['about'] ?? '',
      bio: json['bio'] ?? '',
      birthday: json['birthday'] ?? 'May 20',
      onAirSince: json['onAirSince'] ?? '2016',
      location: json['location'] ?? 'Lagos, Nigeria',
      instagram: json['instagram'] ?? '',
      twitter: json['twitter'] ?? '',
      facebook: json['facebook'] ?? '',
      tiktok: json['tiktok'] ?? '',
    );
  }

  bool isLive([DateTime? now]) {
    return isOnAir || isTimeSlotActive(timeSlot, days, now);
  }

  static bool isTimeSlotActive(String slot, String scheduleDays, [DateTime? now]) {
    if (slot.isEmpty) return false;
    final current = now ?? DateTime.now();

    // 1. Day of week check
    final weekday = current.weekday; // 1 = Monday, 7 = Sunday
    final daysLower = scheduleDays.toLowerCase();

    bool matchesDay = false;
    if (daysLower.contains('daily')) {
      matchesDay = true;
    } else if (daysLower.contains('weekday') || daysLower.contains('mon - fri') || daysLower.contains('mon-fri')) {
      matchesDay = weekday >= DateTime.monday && weekday <= DateTime.friday;
    } else if (daysLower.contains('weekend') || daysLower.contains('sat - sun') || daysLower.contains('sat-sun')) {
      matchesDay = weekday == DateTime.saturday || weekday == DateTime.sunday;
    } else if (daysLower.contains('weeknight')) {
      matchesDay = weekday >= DateTime.monday && weekday <= DateTime.friday;
    } else if ((daysLower.contains('mon') && weekday == DateTime.monday) ||
        (daysLower.contains('tue') && weekday == DateTime.tuesday) ||
        (daysLower.contains('wed') && weekday == DateTime.wednesday) ||
        (daysLower.contains('thu') && weekday == DateTime.thursday) ||
        (daysLower.contains('fri') && weekday == DateTime.friday) ||
        (daysLower.contains('sat') && weekday == DateTime.saturday) ||
        (daysLower.contains('sun') && weekday == DateTime.sunday)) {
      matchesDay = true;
    } else {
      matchesDay = true;
    }

    if (!matchesDay) return false;

    // 2. Time range check (e.g. "6:00 AM - 10:00 AM")
    final parts = slot.split('-');
    if (parts.length != 2) return false;

    final startMinutes = _parseTimeToMinutes(parts[0]);
    final endMinutes = _parseTimeToMinutes(parts[1]);

    if (startMinutes == null || endMinutes == null) return false;

    final currentMinutes = current.hour * 60 + current.minute;

    if (startMinutes <= endMinutes) {
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    } else {
      // Over midnight (e.g. 10:00 PM - 2:00 AM or 12:00 AM - 2:00 AM)
      return currentMinutes >= startMinutes || currentMinutes < endMinutes;
    }
  }

  static int? _parseTimeToMinutes(String timeStr) {
    try {
      final clean = timeStr.trim().toUpperCase();
      final isPM = clean.contains('PM');
      final isAM = clean.contains('AM');

      final numPart = clean.replaceAll('AM', '').replaceAll('PM', '').trim();
      final colonParts = numPart.split(':');
      if (colonParts.isEmpty) return null;

      int hour = int.parse(colonParts[0].trim());
      int minute = colonParts.length > 1 ? int.parse(colonParts[1].trim()) : 0;

      if (isPM && hour < 12) hour += 12;
      if (isAM && hour == 12) hour = 0;

      return hour * 60 + minute;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'showName': showName,
      'timeSlot': timeSlot,
      'days': days,
      'category': category,
      'isOnAir': isOnAir,
      'image': image,
      'tagline': tagline,
      'about': about,
      'bio': bio,
      'birthday': birthday,
      'onAirSince': onAirSince,
      'location': location,
      'instagram': instagram,
      'twitter': twitter,
      'facebook': facebook,
      'tiktok': tiktok,
    };
  }
}
