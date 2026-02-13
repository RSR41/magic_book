import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const removeAdsTileKey = Key('settings_remove_ads_tile');
  static const removeAdsPurchasedIconKey = Key('settings_remove_ads_purchased_icon');
  static const purchaseConfirmButtonKey = Key('settings_purchase_confirm_button');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibration = ref.watch(vibrationProvider);
    final shakeEnabled = ref.watch(shakeEnabledProvider);
    final soundEnabled = ref.watch(soundEnabledProvider);
    final language = ref.watch(languageProvider);
    final isAdFree = ref.watch(isAdFreeProvider);
    final l = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            const SizedBox(height: 16),

            // ─── General ───
            _buildSectionTitle(l.general),
            _buildSwitchTile(
              icon: Icons.vibration,
              title: l.vibration,
              subtitle: l.vibrationSub,
              value: vibration,
              onChanged: (v) {
                ref.read(vibrationProvider.notifier).state = v;
                ref.read(storageServiceProvider).vibration = v;
              },
            ),
            _buildSwitchTile(
              icon: Icons.phone_android,
              title: l.shakeDetection,
              subtitle: l.shakeDetectionSub,
              value: shakeEnabled,
              onChanged: (v) {
                ref.read(shakeEnabledProvider.notifier).state = v;
                ref.read(storageServiceProvider).shake = v;
              },
            ),
            _buildSwitchTile(
              icon: Icons.volume_up_rounded,
              title: l.sound,
              subtitle: l.soundSub,
              value: soundEnabled,
              onChanged: (v) {
                ref.read(soundEnabledProvider.notifier).state = v;
                ref.read(storageServiceProvider).sound = v;
              },
            ),

            const SizedBox(height: 24),

            // ─── Language ───
            _buildSectionTitle(l.language),
            _buildLanguageTile(context, ref, language, l),

            const SizedBox(height: 24),

            // ─── Purchase ───
            _buildSectionTitle(l.purchase),
            _buildListTile(
              key: removeAdsTileKey,
              icon: Icons.block,
              title: l.removeAds,
              subtitle: isAdFree ? l.removeAdsComplete : l.removeAdsPrice,
              trailing: isAdFree
                  ? const Icon(Icons.check_circle,
                      key: removeAdsPurchasedIconKey,
                      color: Colors.green,
                      size: 22)
                  : const Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppTheme.dimGray),
              onTap:
                  isAdFree ? null : () => _showPurchaseDialog(context, ref, l),
            ),
            _buildListTile(
              icon: Icons.restore,
              title: l.restorePurchases,
              subtitle: l.restorePurchasesSub,
              onTap: () => _restorePurchases(context, ref, l),
            ),

            const SizedBox(height: 24),

            // ─── Info ───
            _buildSectionTitle(l.info),
            _buildExpandableTile(
              icon: Icons.warning_amber_rounded,
              title: l.caution,
              content: l.cautionText,
            ),
            _buildExpandableTile(
              icon: Icons.privacy_tip_outlined,
              title: l.privacyPolicy,
              content: l.privacyPolicyText,
            ),
            _buildExpandableTile(
              icon: Icons.article_outlined,
              title: l.termsOfService,
              content: l.termsOfServiceText,
            ),

            // Version + License (small, unobtrusive)
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    '${l.version} 0.1.2',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.dimGray.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: l.appTitle,
                        applicationVersion: '0.1.2',
                      );
                    },
                    child: Text(
                      l.licenses,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.dimGray.withOpacity(0.35),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.accentPurple.withOpacity(0.8),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.1)),
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.accentPurple, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: AppTheme.starWhite,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: TextStyle(
                    color: AppTheme.dimGray.withOpacity(0.7), fontSize: 12))
            : null,
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildListTile({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.1)),
      ),
      child: ListTile(
        enabled: onTap != null,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.accentPurple, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: AppTheme.starWhite,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: TextStyle(
                    color: AppTheme.dimGray.withOpacity(0.7), fontSize: 12))
            : null,
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.arrow_forward_ios,
                    size: 16, color: AppTheme.dimGray)
                : null),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildExpandableTile({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.1)),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentPurple.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.amber.shade400, size: 20),
          ),
          title: Text(title,
              style: const TextStyle(
                  color: AppTheme.starWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          iconColor: AppTheme.dimGray,
          collapsedIconColor: AppTheme.dimGray,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(content,
                  style: TextStyle(
                      color: AppTheme.dimGray.withOpacity(0.8),
                      fontSize: 13,
                      height: 1.6)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, WidgetRef ref,
      String currentLang, AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentPurple.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.language,
              color: AppTheme.accentPurple, size: 20),
        ),
        title: Text(l.language,
            style: const TextStyle(
                color: AppTheme.starWhite,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: currentLang,
            underline: const SizedBox(),
            dropdownColor: AppTheme.cardDark,
            style: const TextStyle(color: AppTheme.starWhite, fontSize: 14),
            items: const [
              DropdownMenuItem(value: 'ko', child: Text('한국어')),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ja', child: Text('日本語')),
              DropdownMenuItem(value: 'zh', child: Text('中文')),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(languageProvider.notifier).state = value;
                ref.read(storageServiceProvider).language = value;
              }
            },
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _showPurchaseDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.removeAds,
            style: const TextStyle(color: AppTheme.starWhite)),
        content: Text(l.purchaseDialogContent,
            style: const TextStyle(color: AppTheme.dimGray)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            key: purchaseConfirmButtonKey,
            onPressed: () async {
              Navigator.pop(ctx);
              final success =
                  await ref.read(iapServiceProvider).purchaseAdRemoval();
              if (success) {
                ref.read(isAdFreeProvider.notifier).state = true;
                ref.read(storageServiceProvider).isAdFree = true;
              }

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(success ? l.removeAdsComplete : l.testMode)),
              );
            },
            child: Text(l.purchaseButton),
          ),
        ],
      ),
    );
  }

  Future<void> _restorePurchases(
      BuildContext context, WidgetRef ref, AppLocalizations l) async {
    final restored = await ref.read(iapServiceProvider).restorePurchases();
    if (restored) {
      ref.read(isAdFreeProvider.notifier).state = true;
      ref.read(storageServiceProvider).isAdFree = true;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(restored ? l.removeAdsComplete : l.testModeRestore)),
    );
  }
}
