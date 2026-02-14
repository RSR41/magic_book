import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAnswers = ref.watch(savedAnswersProvider);
    final locale = ref.watch(languageProvider);
    final l = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: Column(
          children: [
            // Counter + Delete All
            if (savedAnswers.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${savedAnswers.length}/50',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.dimGray.withOpacity(0.6),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showDeleteAllDialog(context, ref, l),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: Text(l.deleteAll),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.dimGray,
                      ),
                    ),
                  ],
                ),
              ),

            // List or empty state
            Expanded(
              child: savedAnswers.isEmpty
                  ? _buildEmptyState(l)
                  : _buildList(context, ref, savedAnswers, locale, l),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentPurple.withOpacity(0.1),
            ),
            child: Icon(
              Icons.history_rounded,
              size: 48,
              color: AppTheme.dimGray.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.noSavedAnswers,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.dimGray.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.noSavedAnswersSub,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.dimGray.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List savedAnswers,
      String locale, AppLocalizations l) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: savedAnswers.length,
      itemBuilder: (context, index) {
        final saved = savedAnswers[index];
        return Dismissible(
          key: Key(saved.answerId + saved.savedAt.toIso8601String()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_outline, color: Colors.red),
          ),
          onDismissed: (direction) {
            ref
                .read(soundServiceProvider)
                .playSfx('sfx_button.wav'); // Deletion sound
            ref
                .read(savedAnswersProvider.notifier)
                .deleteAnswer(saved.answerId);
          },
          child: GestureDetector(
            onTap: () => _showDetailDialog(context, ref, saved, locale, l),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.accentPurple.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (saved.question.isNotEmpty && saved.question != '고민')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.help_outline,
                              size: 14,
                              color: AppTheme.accentCyan.withOpacity(0.6)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(saved.question,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.dimGray.withOpacity(0.7)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    saved.getLocalizedText(locale),
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.starWhite,
                        height: 1.3),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    saved.getLocalizedSubtext(locale),
                    style: TextStyle(
                        fontSize: 13, color: AppTheme.dimGray.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.access_time,
                          size: 12, color: AppTheme.dimGray.withOpacity(0.4)),
                      const SizedBox(width: 4),
                      Text(_formatDate(saved.savedAt),
                          style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.dimGray.withOpacity(0.4))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetailDialog(BuildContext context, WidgetRef ref, dynamic saved,
      String locale, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (saved.question.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Q: ${saved.question}',
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.accentCyan,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                ),
              // Star icon removed as requested
              const SizedBox(height: 20),
              Text(
                saved.getLocalizedText(locale),
                style: GoogleFonts.cinzelDecorative(
                    // Changed to Cinzel Decorative
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.starWhite,
                    height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(saved.getLocalizedSubtext(locale),
                  style: const TextStyle(fontSize: 14, color: AppTheme.dimGray),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Text(_formatDate(saved.savedAt),
                  style: TextStyle(
                      fontSize: 12, color: AppTheme.dimGray.withOpacity(0.5))),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _DetailActionButton(
                    icon: Icons.delete_outline,
                    label: l.delete,
                    color: Colors.red.shade300,
                    onTap: () {
                      Navigator.pop(dialogContext);
                      ref.read(soundServiceProvider).playSfx('sfx_button.wav');
                      ref
                          .read(savedAnswersProvider.notifier)
                          .deleteAnswer(saved.answerId);
                    },
                  ),
                  const SizedBox(width: 16),
                  _DetailActionButton(
                    icon: Icons.share_outlined,
                    label: l.share,
                    color: AppTheme.accentCyan,
                    onTap: () {
                      final text = l.shareFormat(
                        saved.question,
                        saved.getLocalizedText(locale),
                        saved.getLocalizedSubtext(locale),
                      );
                      Share.share(text);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Close
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.dimGray,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(l.close,
                      style: GoogleFonts.cinzelDecorative(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAllDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.deleteAll,
            style: const TextStyle(color: AppTheme.starWhite)),
        content: Text(l.deleteAllConfirm,
            style: const TextStyle(color: AppTheme.dimGray)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              ref.read(soundServiceProvider).playSfx('sfx_button.wav');
              ref.read(savedAnswersProvider.notifier).deleteAll();
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l.delete),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DetailActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: GoogleFonts.cinzelDecorative(
                    // Magical rune-like font
                    fontSize: 15,
                    color: color,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
