import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/blog_repository.dart';
import '../models/post_model.dart';

final blogRepositoryProvider = Provider((ref) => BlogRepository());

final blogPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  return await ref.watch(blogRepositoryProvider).getPosts();
});

final postDetailsProvider = FutureProvider.family<PostModel, String>((ref, id) async {
  return await ref.watch(blogRepositoryProvider).getPostById(id);
});
