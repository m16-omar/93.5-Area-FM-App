import 'package:flutter/material.dart';
import '../../../../common/components/news_card.dart';
import '../../../models/post_model.dart';

class PostCardWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;

  const PostCardWidget({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NewsCard(post: post, onTap: onTap);
  }
}
