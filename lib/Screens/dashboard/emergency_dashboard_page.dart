import 'dart:math' as math;
import '../../services/emergency_service.dart';
import '../../models/emergency_status.dart';
import '../../models/emergency_incident.dart';
import '../../models/emergency_feed.dart';
import '../../models/emergency_personnel.dart';
import '../../models/emergency_contact.dart';
import '../../models/emergency_system.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../theme/app_theme.dart';

class EmergencyDashboardPage extends StatefulWidget {
  const EmergencyDashboardPage({super.key});
class _EmergencyDashboardPageState extends State<EmergencyDashboardPage>
    with SingleTickerProviderStateMixin {
  EmergencyStatus? _emergencyStatus;
  ActiveIncident? _activeIncident;
  List<IncidentFeedItem> _incidentFeed = [];
   EmergencySystemStatus? _systemStatus;
  bool _isLoading = true;

  late final AnimationController _pulseController;
    }

  @override
  void initState() {
    super.initState();
    _loadEmergencyData();
    @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

    Future<void> _loadEmergencyData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
  }
  @override
    Widget build(BuildContext context) {
  if (_isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  final palette = _EmergencyPalette(
    Theme.of(context).brightness == Brightness.dark,
  );
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [palette.page, palette.pageAlt],
      ),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 980;
        return Padding(
          padding: EdgeInsets.fromLTRB(20, compact ? 12 : 16, 20, 20),
          child: compact
              ? _CompactEmergencyBody(
                  palette: palette,
                  pulseController: _pulseController,
                  emergencyStatus: _emergencyStatus,
                  activeIncident: _activeIncident,
                  incidentFeed: _incidentFeed,
                  personnel: _personnel,
                  contacts: _contacts,
                  systemStatus: _systemStatus,
                )
              : _DesktopEmergencyBody(
                  palette: palette,
                  pulseController: _pulseController,
                  emergencyStatus: _emergencyStatus,
                  activeIncident: _activeIncident,
                  incidentFeed: _incidentFeed,
                  personnel: _personnel,
                  contacts: _contacts,
                  systemStatus: _systemStatus,
                ),
        );
      },
    ),
  );
}
class _ContactsCard extends StatelessWidget {
  final _EmergencyPalette palette;
  final List<EmergencyContact> contacts;

  const _ContactsCard({
    required this.palette,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {  
     final displayContacts = contacts.isEmpty
        ? [('Emergency Services', '911', 'emergency')]
        : contacts.map((c) => (c.name, c.number, c.type)).toList();
    return _Panel(
      palette: palette,
      title: 'Emergency Contacts',
      trailing: _MiniButton(palette: palette, label: 'View All'),
      child: Column(
        children: [
          for (int i = 0; i < displayContacts.length && i < 2; i++) ...[
            if (i > 0) Divider(color: palette.line, height: 1),
            _ContactTile(
              palette: palette,
              icon: displayContacts[i].$3 == 'emergency'
                  ? Icons.call_rounded
                  : Icons.shield_rounded,
              title: displayContacts[i].$1,
              subtitle: displayContacts[i].$2,
            ),
          ],
        ],
      ),
    );
  }
}
        required this.palette,
    required this.pulseController,
    required this.emergencyStatus,
    required this.activeIncident,
    required this.incidentFeed,
    required this.personnel,
    required this.contacts,
    required this.systemStatus,

  const _DesktopEmergencyBody({
    required this.palette,
    required this.pulseController,
  });

  @override

        _EmergencyBanner(
         palette: palette,
         pulseController: pulseController,
          ),
          const SizedBox(height: 18),
         _StatsRow(palette: palette),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(
                      height: 280,
                         child: _LiveMapCard(palette: palette),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 220,
                             child: _PersonnelCard(palette: palette),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: SizedBox(
                            height: 220,
                             child: _ContactsCard(palette: palette),
                          ),
                        ),
                      ],
                      children: [
                    SizedBox(
                      height: 260,
                      child: _ActiveIncidentCard(palette: palette),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 250,
                      child: _IncidentFeedCard(palette: palette),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
         _SystemStrip(palette: palette),
        ],
      ),
    );
  }
}

class _CompactEmergencyBody extends StatelessWidget {
  final _EmergencyPalette palette;
  final AnimationController pulseController;
  final EmergencyStatus? emergencyStatus;
  final ActiveIncident? activeIncident;
  final EmergencySystemStatus? systemStatus;

  const _CompactEmergencyBody({
     required this.palette,
    required this.pulseController,
    required this.emergencyStatus,
    required this.activeIncident,
@@ -266,73 +269,36 @@

  @override
  Widget build(BuildContext context) {
     if (_isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
    return SingleChildScrollView(
      child: Column(
        children: [
          _EmergencyBanner(
            palette: palette,
            pulseController: pulseController,
             ),
          const SizedBox(height: 14),
          _StatsRow(palette: palette),
          const SizedBox(height: 14),
          SizedBox(height: 280, child: _ActiveIncidentCard(palette: palette)),
          const SizedBox(height: 14),
           SizedBox(height: 230, child: _IncidentFeedCard(palette: palette)),
          const SizedBox(height: 14),
           SizedBox(height: 220, child: _PersonnelCard(palette: palette)),
          const SizedBox(height: 14),
           SizedBox(height: 220, child: _ContactsCard(palette: palette)),
          const SizedBox(height: 14),
           _SystemStrip(palette: palette),
        ],
      ),
    );
  }
}
class _EmergencyBanner extends StatelessWidget {
  final _EmergencyPalette palette;
  final AnimationController pulseController;
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                 palette.redDark.withValues(alpha: 0.45),
                palette.card,
                ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.red.withValues(alpha: 0.75)),
            boxShadow: [
              BoxShadow(
                 color: palette.red.withValues(alpha: glow),
                blurRadius: 22,
              ),
            ],
            width: 42,
                height: 42,
                decoration: BoxDecoration(
                   color: palette.red.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                   border: Border.all(color: palette.red.withValues(alpha: 0.85)),
                ),
                child: Icon(Icons.warning_amber_rounded,
                    color: palette.redHot, size: 30),
    );
  }
}

class _LiveMapCard extends StatelessWidget {
  final _EmergencyPalette palette;
  final EmergencyStatus? emergencyStatus;

  @override
  Widget build(BuildContext context) {
    // تحديد موقع الحادث بناءً على الـ zone من الـ emergencyStatus
    final incidentZone = emergencyStatus?.zone ?? 'Zone 1';
    final isActive = emergencyStatus?.mode == 'ACTIVE';

    // تحديد إحداثيات الحادث على الخريطة حسب المنطقة
    Offset incidentOffset;
    switch (incidentZone) {
      case 'Zone 1':
              borderRadius: BorderRadius.circular(8),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    palette.page.withValues(alpha: 0.28),
                  BlendMode.srcATop,
                ),
                child: Image.asset(
    return '$hour:$minute $suffix';
  }
}
class _IncidentFeedCard extends StatelessWidget {
  final _EmergencyPalette palette;
  final List<IncidentFeedItem> incidentFeed;
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: event.$4.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                     border: Border.all(color: event.$4.withValues(alpha: 0.6)),
                  ),
                  child: Icon(event.$5, color: event.$4, size: 17),
                ),
    }
  }
}

class _PersonnelCard extends StatelessWidget {
  final _EmergencyPalette palette;
  final List<EmergencyPersonnel> personnel;
  }
}
                  class _SystemStrip extends StatelessWidget {
  final _EmergencyPalette palette;
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                       color: items[i].$4.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(items[i].$3, color: items[i].$4, size: 15),
  }
}
                  class _Panel extends StatelessWidget {
  final _EmergencyPalette palette;
  final String title;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: active ? palette.redDark.withValues(alpha: 0.32) : palette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? palette.red.withValues(alpha: 0.55) : palette.border,
        ),
      ),
      child: Row(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: spec.color.withValues(alpha: 0.13),
              shape: BoxShape.circle,
                border: Border.all(color: spec.color.withValues(alpha: 0.35)),
            ),
            child: Icon(spec.icon, color: spec.color, size: 21),
          ),
        children: [
          CircleAvatar(
            radius: 17,
                  backgroundColor: color.withValues(alpha: 0.16),
            child: Text(
              initials,
              style: TextStyle(color: color, fontWeight: FontWeight.w900),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
               color: palette.red.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: palette.redHot, size: 17),
  }
}

// ignore: unused_element
class _LanguagePill extends StatelessWidget {
  final _EmergencyPalette palette;

  const _LanguagePill({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Text('EN',
              style: TextStyle(
                  color: palette.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w900)),
          const SizedBox(width: 14),
          Text('عربي',
              style: TextStyle(
                  color: palette.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _NotificationBell extends StatelessWidget {
  final _EmergencyPalette palette;

  const _NotificationBell({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _SquareIconButton(
          palette: palette,
          icon: Icons.notifications_none_rounded,
          onPressed: () {},
        ),
        Positioned(
          right: -4,
          top: -6,
          child: CircleAvatar(
            radius: 9,
            backgroundColor: palette.redHot,
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final _EmergencyPalette palette;
  final IconData icon;
  final VoidCallback onPressed;

  const _SquareIconButton({
    required this.palette,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.text,
          backgroundColor: palette.card,
          side: BorderSide(color: palette.border),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final _EmergencyPalette palette;
  final IconData icon;

  const _SmallIconButton({required this.palette, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: palette.control,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: palette.border),
      ),
      child: Icon(icon, color: palette.muted, size: 15),
    );
  }
}
class _MiniButton extends StatelessWidget {
  final _EmergencyPalette palette;
  final String label;

  const _MiniButton({
    required this.palette,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      ) ,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: palette.control,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: palette.text,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PriorityPill extends StatelessWidget {
  final _EmergencyPalette palette;

  const _PriorityPill({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: palette.red.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: palette.red.withValues(alpha: 0.45)),
      ),
      child: Text(
        'High Priority',
        style: TextStyle(
          color: palette.redHot,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BannerAction extends StatelessWidget {
  final _EmergencyPalette palette;
  final IconData icon;

      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border(
           left: BorderSide(color: palette.red.withValues(alpha: 0.24)),
        ),
      ),
      child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9DB2D8),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ignore: unused_element
class _StatusDot extends StatelessWidget {
  final Color color;

  const _StatusDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 8)
        ],
      ),
    );
  }
}

class _SituationMapPainter extends CustomPainter {
  final _EmergencyPalette palette;

  const _SituationMapPainter({required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    final incident = Offset(size.width * 0.57, size.height * 0.54);
    for (var i = 4; i >= 1; i--) {
      canvas.drawCircle(
        incident,
        i * 18,
        Paint()
          ..color = palette.red.withValues(alpha: 0.045)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        incident,
        i * 18,
        Paint()
          ..color = palette.red.withValues(alpha: 0.16)
          ..style = PaintingStyle.stroke,
      );
    }
    _drawNode(canvas, size, incident, palette.red, Icons.warning_rounded);
    _drawNode(canvas, size, Offset(size.width * 0.22, size.height * 0.58),
        palette.green, Icons.directions_bus_rounded);
    _drawNode(canvas, size, Offset(size.width * 0.74, size.height * 0.42),
        palette.green, Icons.directions_bus_rounded);
    _drawNode(canvas, size, Offset(size.width * 0.38, size.height * 0.24),
        palette.blue, Icons.security_rounded);
    _drawNode(canvas, size, Offset(size.width * 0.79, size.height * 0.72),
        palette.gold, Icons.videocam_rounded);
    _drawPath(
        canvas,
        size,
        [
          Offset(size.width * 0.12, size.height * 0.37),
          Offset(size.width * 0.25, size.height * 0.28),
          Offset(size.width * 0.31, size.height * 0.33),
        ],
        palette.redHot);
    _drawPath(
        canvas,
        size,
        [
          Offset(size.width * 0.68, size.height * 0.33),
          Offset(size.width * 0.82, size.height * 0.47),
          Offset(size.width * 0.91, size.height * 0.40),
        ],
        palette.blue);
  }

  void _drawPath(Canvas canvas, Size size, List<Offset> points, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawNode(
    Canvas canvas,
    Size size,
    Offset center,
    Color color,
    IconData icon,
  ) {
    canvas.drawCircle(
      center,
      16,
      Paint()..color = color.withValues(alpha: 0.16),
    );
    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = palette.card
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
          fontSize: 15,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _SituationMapPainter oldDelegate) =>
      oldDelegate.palette != palette;
}

class _HeartbeatPainter extends CustomPainter {
  final Color color;

  const _HeartbeatPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(0, size.height * 0.55);
    for (var i = 1; i < 12; i++) {
      final x = size.width * i / 11;
      final spike = i == 4 || i == 8;
      final y = spike
          ? size.height * 0.14
          : size.height * (0.52 + math.sin(i) * 0.10);
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartbeatPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _StatSpec {
  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color color;

  const _StatSpec(
    this.label,
    this.value,
    this.caption,
    this.icon,
    this.color,
  );
}

class _EmergencyPalette {
  final bool isDark;

  const _EmergencyPalette(this.isDark);

  Color get page => isDark ? const Color(0xFF020914) : AppTheme.lightBackground;
  Color get pageAlt =>
      isDark ? const Color(0xFF03182C) : const Color(0xFFEAF4FF);
  Color get card => isDark ? const Color(0xFF061A2F) : Colors.white;
  Color get control =>
      isDark ? const Color(0xFF071F3B) : const Color(0xFFF3F8FF);
  Color get border =>
      isDark ? const Color(0xFF0D4A79) : const Color(0xFFC8DFFF);
  Color get line => isDark ? const Color(0xFF123554) : const Color(0xFFD9E7FA);
  Color get text => isDark ? Colors.white : const Color(0xFF061B44);
  Color get muted => isDark ? const Color(0xFF9DB2D8) : const Color(0xFF577099);
  Color get shadow => isDark
      ? Colors.black.withValues(alpha: 0.22)
      : const Color(0xFF9CC9FF).withValues(alpha: 0.18);
  Color get blue => const Color(0xFF0EA5FF);
  Color get green => const Color(0xFF18D47B);
  Color get gold => const Color(0xFFFFB020);
  Color get red => const Color(0xFFE53935);
  Color get redHot => const Color(0xFFFF4040);
  Color get redDark => const Color(0xFF4D0B14);
}

          
  
