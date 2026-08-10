import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/support_repository.dart';

final supportRepositoryProvider = Provider((ref) => SupportRepository());
