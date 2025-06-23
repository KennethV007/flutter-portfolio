// Imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:lottie/lottie.dart';
import 'dart:html';


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
                            'Kenneth George Valladares',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Software Development Intern @ Toptech Systems | Flutter & Web Dev Enthusiast',
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
                  "I'm a passionate developer with a passion for full-stack development. "
                  "I enjoy building web and mobile applications that solve real-world problems. " 
                  " I apply my skills through projects, internships, and ideas that contribute to the progress of the digital age.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),

                // Resume Button
                ElevatedButton(
                  onPressed: () {
                    const url = 'assets/resume.pdf';
                    AnchorElement(href: url)
                      ..setAttribute('download', 'Kenneth_Resume.pdf') // <- sets the filename
                      ..click();
                  },
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
                    ProjectCard(title: 'Fitness Tracker App', description: 'Tracks and suggests workouts for beginners using MERN.'),
                    ProjectCard(title: 'Nokia Contact Manager', description: 'LAMP Stack contact manager with a retro feel.'),
                    ProjectCard(title: 'Portfolio Website', description: 'This site, built in Flutter and hosted on Firebase.'),
                    ProjectCard(title: 'Orlando Korean Culture Center Website', description: 'Function, homegrown website built for the OKCC to automate payments and signsups using PERN.'),
                    ProjectCard(title: 'Autocommit.AI', description: 'To be announced: Github auto committer with AI changelist generation.'),
                    ProjectCard(title: 'Stride', description: 'To be announced: Practical tool for runners to improve form using AI, Machine Learning, and Computer Vision.'),
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
                    TimelineEvent(year: '2022', event: 'Discovered computer science during AP Principles'),
                    TimelineEvent(year: '2023', event: 'Started CS degree at UCF.'),
                    TimelineEvent(year: '2024', event: 'Built first data structures (2-4 Tree and SkipList.)'),
                    TimelineEvent(year: '2025', event: 'Accepted into the UCF Accelerated Masters program'),
                    TimelineEvent(year: '2025', event: 'Begun internship at Toptech Systems'),
                    TimelineEvent(year: '2027', event: 'Graduating and seeking Software Engineer role at big tech'),
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
                    CourseChip('Intro to Progamming'),
                    CourseChip('Object-Oriented Programming in Java'),
                    CourseChip('Computer Science 1'),
                    CourseChip('Computer Science 2'),
                    CourseChip('Security in Computing'),
                    CourseChip('Computer Logic and Organization'),
                    CourseChip('Systems Software'),
                    CourseChip('Discrete Mathematics'),
                    CourseChip('Processes of Object-Oriented Software Development'),
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
                        'My Dream',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "One day, I hope to live and work between two of the most beautiful and important cities in the world — Seoul and Washington D.C. " 
                        "Their contrast in culture, architecture, and pace of life has inspired me to dream big and think globally. "
                        "There is so much more to the world than my home town. I hope to travel between these cities to enrich myself in Korean culture, "
                        "learn more about American History, and become fluent in English, Spanish, and Korean. My favorite flower is the cherry blossom or 벚꽃." 
                        "If given the privilege to live in Washington D.C. I hope to grow my own cherry blossoms.",
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
                        "These cities have reminded me that it is okay to take risks, to leave your comfort zone, and to fall in love with the uncertain. They are opposite to the casual "
                        "suburban life that I am used to. Cities are high energy environments bustling with creativity, ambition, and opportunity. Moving to a big city is the physical embodiement "
                        "of stepping out of a comfort zone to pursue opportunity. The cities have endless opportunity for business, software, and cultural enrichiment. "
                        "I live by the belief that nothing is my life is written until I accomplish it. I believe the future is created by those who are brave enough to chase what matters most to them. "
                        "Although I am just starting my career, I have the big picture in mind. My goal is to make long-lasting contributions to this planet in the form of software, service, "
                        "and my future family. When I retire, I would like to look back on all that I have accomplished in my life and be proud of what I did. "
                        "I aspire to live with no regrets by always pursuing improvement, ambition, and the welfare of those around me. Below is a picture from one of my favorite shows. " 
                        "This image represents the admiration for our beautiful world for what it is. Earth can be scary for some but exciting for others. Perspective determines what one sees "
                        "and so I choose to see opportunities in everything.",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          '"Opportunities are like sunrises. If you wait too long, you miss them," - William Arthur Ward',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const StaticImage(imagePath: 'assets/vision.jpg'),
                    ],
                  ),
                ),
                const SizedBox(height: 80),

                const Center(
                  child: Text(
                    '© 2025 Kenneth George Valladares • Built with Flutter Web',
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

