import 'package:flutter_test/flutter_test.dart';
import 'package:sqlquest/shared/models/user_model.dart';
import 'package:sqlquest/core/providers/app_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Gamification PRD Formula Tests', () {
    test('XP kumulatif matches PRD formula: 50 * L * (L - 1)', () {
      expect(UserModel.cumulativeXpForLevel(1), 0);
      expect(UserModel.cumulativeXpForLevel(2), 100);
      expect(UserModel.cumulativeXpForLevel(3), 300);
      expect(UserModel.cumulativeXpForLevel(4), 600);
      expect(UserModel.cumulativeXpForLevel(5), 1000);
      expect(UserModel.cumulativeXpForLevel(10), 4500);
    });

    test('Titles match PRD levels', () {
      expect(UserModel.getTitleForLevel(1), 'SQL Beginner');
      expect(UserModel.getTitleForLevel(2), 'Query Learner');
      expect(UserModel.getTitleForLevel(3), 'Query Explorer');
      expect(UserModel.getTitleForLevel(4), 'SQL Practitioner');
      expect(UserModel.getTitleForLevel(5), 'SQL Specialist');
      expect(UserModel.getTitleForLevel(10), 'SQL Master');
    });

    test('UserNotifier awards XP and levels up when threshold reached', () {
      final container = ProviderContainer();
      final userNotifier = container.read(userProvider.notifier);

      expect(container.read(userProvider).level, 3);
      expect(container.read(userProvider).totalXp, 420);

      // Add 200 XP -> total 620 XP (exceeds 600 XP threshold for Level 4)
      userNotifier.addXp(200);

      final updatedUser = container.read(userProvider);
      expect(updatedUser.totalXp, 620);
      expect(updatedUser.level, 4);
      expect(updatedUser.levelTitle, 'SQL Practitioner');
    });

    test('Claiming mission updates state and increments XP', () {
      final container = ProviderContainer();
      final missionsNotifier = container.read(missionsProvider.notifier);
      final userNotifier = container.read(userProvider.notifier);

      final initialXp = container.read(userProvider).totalXp;
      final mission = container.read(missionsProvider).firstWhere((m) => m.id == 'mis_1');

      expect(mission.isCompleted, true);
      expect(mission.isClaimed, false);

      userNotifier.addXp(mission.xpReward);
      missionsNotifier.claimMission(mission.id);

      expect(container.read(userProvider).totalXp, initialXp + 50);
      expect(container.read(missionsProvider).firstWhere((m) => m.id == 'mis_1').isClaimed, true);
    });
  });
}
