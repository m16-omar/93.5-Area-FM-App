import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/components/section_header.dart';
import '../../../../common/components/news_card.dart';
import '../../../models/post_model.dart';

class LatestNewsWidget extends StatelessWidget {
  final List<PostModel> news;

  const LatestNewsWidget({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Latest News & Stories',
          actionText: 'Read More',
          onActionTap: () => context.go('/blog'),
        ),
        const SizedBox(height: 12),
        Column(
          children: news
              .map(
                (post) => NewsCard(
                  post: post,
                  onTap: () => context.push('/post_details/${post.id}'),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
