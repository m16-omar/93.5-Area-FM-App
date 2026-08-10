import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/team_repository.dart';
import '../models/team_member_model.dart';

final teamRepositoryProvider = Provider((ref) => TeamRepository());

final teamMembersProvider = FutureProvider<List<TeamMemberModel>>((ref) async {
  return await ref.watch(teamRepositoryProvider).getTeamMembers();
});

final teamMemberDetailsProvider = FutureProvider.family<TeamMemberModel, String>((ref, id) async {
  return await ref.watch(teamRepositoryProvider).getTeamMemberById(id);
});
