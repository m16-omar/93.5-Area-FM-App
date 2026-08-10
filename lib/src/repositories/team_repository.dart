import '../models/team_member_model.dart';

class TeamRepository {
  Future<List<TeamMemberModel>> getTeamMembers() async {
    return const [
      TeamMemberModel(
        id: 't1',
        name: 'Chief Michael O.',
        role: 'General Manager',
        image: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=600&q=80',
        bio: 'Over 20 years of broadcast leadership driving innovation in urban radio streaming.',
        email: 'gm@area935fm.com',
      ),
      TeamMemberModel(
        id: 't2',
        name: 'Victoria Adams',
        role: 'Head of Programs',
        image: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=600&q=80',
        bio: 'Curates hit radio programs, talent development, and daily broadcast schedules.',
        email: 'programs@area935fm.com',
      ),
    ];
  }

  Future<TeamMemberModel> getTeamMemberById(String id) async {
    final team = await getTeamMembers();
    return team.firstWhere((t) => t.id == id, orElse: () => team.first);
  }
}
