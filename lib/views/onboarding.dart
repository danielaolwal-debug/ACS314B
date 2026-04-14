import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'icon': Icons.menu_book_rounded,
      'title': 'Learn Smart',
      'desc': 'Master subjects with structured lessons and practice.',
      'color': const Color(0xFF2E7D32),
    },
    {
      'icon': Icons.quiz_rounded,
      'title': 'Test Yourself',
      'desc': 'Quizzes after every lesson to reinforce learning.',
      'color': const Color(0xFF4CAF50),
    },
    {
      'icon': Icons.leaderboard_rounded,
      'title': 'Track Progress',
      'desc': 'See your improvement and compete with friends.',
      'color': const Color(0xFF66BB6A),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFE8F5E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: pages.length,
                  itemBuilder: (context, i) {
                    final page = pages[i];
                    return Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon with glow
                          Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  page['color'],
                                  page['color'].withValues(alpha: 0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(80),
                              boxShadow: [
                                BoxShadow(
                                  color: (page['color'] as Color).withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              page['icon'],
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            page['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: page['color'],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              page['desc'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Dots + Buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 10,
                          width: _currentPage == i ? 32 : 10,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? pages[i]['color']
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Get.offAllNamed('/'),
                          child: Text(
                            "Skip",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_currentPage < pages.length - 1) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Get.offAllNamed('/');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pages[_currentPage]['color'],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _currentPage < pages.length - 1
                                ? "Next"
                                : "Get Started",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
