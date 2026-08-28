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
