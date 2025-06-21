// Imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:lottie/lottie.dart';

// Fade-in animation widget
class FadeInOnScroll extends StatefulWidget {
  final Widget child;
  final int delay;
  const FadeInOnScroll({super.key, required this.child, this.delay = 0});

  @override
  State<FadeInOnScroll> createState() => _FadeInOnScrollState();
}

class _FadeInOnScrollState extends State<FadeInOnScroll> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fade, child: widget.child);
  }
}

// Project card with hover effect
class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  const ProjectCard({super.key, required this.title, required this.description});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_hovering ? 1.02 : 1.0),
        decoration: BoxDecoration(boxShadow: [
          if (_hovering)
            const BoxShadow(
              color: Colors.tealAccent,
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 4),
            )
        ]),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              Text(widget.description, style: const TextStyle(fontSize: 15, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class StaticImage extends StatelessWidget {
  final String imagePath;
  final double height;
  const StaticImage({super.key, required this.imagePath, this.height = 480});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}


// Animated gradient background wrapper
class AnimatedGradientBackground extends StatelessWidget {
  final Widget child;
  const AnimatedGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Lottie.asset(
            'assets/animated_gradient.json',
            fit: BoxFit.cover,
            repeat: true,
            animate: true,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.65)),
        ),
        child,
      ],
    );
  }
}

// Launches app
void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Arial',
      ).copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AnimatedGradientBackground(child: PortfolioPage()),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Timeline event structure
class TimelineEvent extends StatelessWidget {
  final String year;
  final String event;
  const TimelineEvent({super.key, required this.year, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(year, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
          const SizedBox(width: 16),
          Expanded(child: Text(event, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

// Course tag chips
class CourseChip extends StatelessWidget {
  final String courseName;
  const CourseChip(this.courseName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Chip(
        backgroundColor: Colors.grey[900],
        side: const BorderSide(color: Colors.teal),
        label: Text(courseName, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Your Name',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Aspiring Software Engineer | Flutter & Web Dev Enthusiast',
                            style: TextStyle(fontSize: 18, color: Colors.white70),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 40),

                // About Me
                const Text(
                  'About Me',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  "I'm a passionate developer with experience in full-stack development. I enjoy building web and mobile applications that solve real-world problems. Let's connect and create something amazing together!",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),

                // Resume Button
                ElevatedButton(
                  onPressed: () => _launchURL('https://example.com/resume.pdf'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text('Download Resume', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 48),

                // Projects Section
                const Text(
                  'Projects',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    ProjectCard(title: 'Fitness Tracker App', description: 'Tracks workouts with Flutter and Supabase.'),
                    ProjectCard(title: 'Smart Budgeting Tool', description: 'MERN app with analytics and Stripe integration.'),
                    ProjectCard(title: 'Portfolio Website', description: 'This site, built in Flutter and hosted on Vercel.'),
                    ProjectCard(title: 'AI Note Summarizer', description: 'Summarizes uploaded text using Gemini AI API.'),
                    ProjectCard(title: 'Social Chat App', description: 'Flutter-Firebase chat app with user auth and storage.'),
                    ProjectCard(title: 'Weather Forecast App', description: 'Clean and animated weather app using OpenWeatherMap.'),
                  ],
                ),
                const SizedBox(height: 48),

                // Timeline Section
                const Text(
                  'My Journey',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Column(
                  children: const [
                    TimelineEvent(year: '2023', event: 'Started CS degree at UCF.'),
                    TimelineEvent(year: '2022', event: 'Built first Flutter mobile app.'),
                    TimelineEvent(year: '2023', event: 'Interned at Company A and launched production tool.'),
                    TimelineEvent(year: '2024', event: 'Started full-stack portfolio and began AI specialization.'),
                    TimelineEvent(year: '2027', event: 'Graduating and seeking Software Engineer role.'),
                  ],
                ),
                const SizedBox(height: 48),

                // Courses Section
                const Text(
                  'Courses Taken',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CourseChip('Data Structures & Algorithms'),
                    CourseChip('Object-Oriented Programming in Java'),
                    CourseChip('Operating Systems'),
                    CourseChip('Database Systems (SQL, NoSQL)'),
                    CourseChip('Web Development with MERN'),
                    CourseChip('Mobile App Dev with Flutter'),
                    CourseChip('AI & Machine Learning Basics'),
                    CourseChip('Compiler Design & Architecture'),
                    CourseChip('Cloud Computing with AWS'),
                  ],
                ),
                const SizedBox(height: 48),

                // My Dreams Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Dreams',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'One day, I hope to live and work between two of the most beautiful cities I have ever visited — Seoul and Washington D.C. Their contrast in culture, architecture, and pace of life has inspired me to dream big and think globally.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Expanded(child: StaticImage(imagePath: 'assets/seoul.jpg', height: 300)),
                          SizedBox(width: 16),
                          Expanded(child: StaticImage(imagePath: 'assets/dc.jpg', height: 300)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'These cities have reminded me that it is okay to take risks, to leave your comfort zone, and to fall in love with uncertainty. I believe the future is written by those who are brave enough to chase what matters most to them.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const StaticImage(imagePath: 'assets/vision.jpg'),
                    ],
                  ),
                ),
                const SizedBox(height: 80),

                const Center(
                  child: Text(
                    '© 2025 Your Name • Built with Flutter Web',
                    style: TextStyle(fontSize: 14, color: Colors.white38),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

