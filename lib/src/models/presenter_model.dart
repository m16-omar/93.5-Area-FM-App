import 'package:flutter/material.dart';

class PresenterModel {
  final String id;
  final String name;
  final String showName;
  final String timeSlot;
  final String category;
  final bool isOnAir;
  final String image;
  final String bio;
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
    this.category = 'Presenters',
    this.isOnAir = false,
    required this.image,
    required this.bio,
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
      category: json['category'] ?? 'Presenters',
      isOnAir: json['isOnAir'] ?? false,
      image: json['image'] ?? '',
      bio: json['bio'] ?? '',
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
      'category': category,
      'isOnAir': isOnAir,
      'image': image,
      'bio': bio,
      'instagram': instagram,
      'twitter': twitter,
      'facebook': facebook,
      'tiktok': tiktok,
    };
  }
}
