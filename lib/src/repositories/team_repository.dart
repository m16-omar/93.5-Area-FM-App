import '../../const/app_assets.dart';
import '../models/team_member_model.dart';

class TeamRepository {
  Future<List<TeamMemberModel>> getTeamMembers() async {
    return const [
      TeamMemberModel(
        id: 't_adedoja_allen',
        name: 'Adedoja Allen',
        role: 'MD / CEO',
        image: AppAssets.adedojaAllen,
        bio: 'Managing Director/CEO of City 105.1FM and 93.5 Area FM. Over a decade of visionary executive leadership driving transformative media and community initiatives.',
        email: 'md@935areafm.com',
      ),
    ];
  }

  Future<TeamMemberModel> getTeamMemberById(String id) async {
    final team = await getTeamMembers();
    return team.firstWhere((t) => t.id == id, orElse: () => team.first);
  }
}
