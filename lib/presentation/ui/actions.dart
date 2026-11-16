import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/assets.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternal(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {
    // A blocked pop-up is the browser's call; nothing useful to show.
  }
}

void openResume() => openExternal(Assets.resumeUrl);

Future<void> copyToClipboard(
  BuildContext context,
  String text, {
  required String confirmation,
}) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  await Clipboard.setData(ClipboardData(text: text));
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(confirmation),
        duration: const Duration(seconds: 2),
      ),
    );
}

void copyEmail(BuildContext context) => copyToClipboard(
      context,
      PortfolioContent.profile.email,
      confirmation: 'Email address copied',
    );

/// Button text for a project's main link, named after where it goes.
String projectLinkLabel(String url) {
  if (url.contains('apps.apple.com')) return 'View on the App Store';
  if (url.contains('play.google.com')) return 'View on Google Play';
  if (url.contains('github.com')) return 'View source on GitHub';
  return 'Open live product';
}

/// Short destination name for list rows: "Live", "GitHub", "App Store".
String projectLinkKind(String url) {
  if (url.contains('apps.apple.com')) return 'App Store';
  if (url.contains('play.google.com')) return 'Google Play';
  if (url.contains('github.com')) return 'GitHub';
  return 'Live';
}

IconData projectLinkIcon(String url) {
  if (url.contains('apps.apple.com')) return FontAwesomeIcons.appStoreIos;
  if (url.contains('play.google.com')) return FontAwesomeIcons.googlePlay;
  if (url.contains('github.com')) return FontAwesomeIcons.github;
  return Icons.language;
}

String hostOf(String url) {
  final host = Uri.tryParse(url)?.host ?? url;
  return host.startsWith('www.') ? host.substring(4) : host;
}
