import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      'icon': Icons.menu_book,
      'title': 'Learn Anything',
      'desc': 'Access subjects and lessons designed to help you study smarter.',
      'color': Colors.green,
    },
    {
      'icon': Icons.quiz,
      'title': 'Test Yourself',
      'desc': 'Take quizzes after each lesson to reinforce what you learned.',
      'color': Colors.teal,
    },
    {
      'icon': Icons.leaderboard,
      'title': 'Track Progress',
      'desc': 'See your scores, climb the leaderboard and stay motivated.',
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                        Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                            color: (page['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 80,
                            color: page['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page['title'] as String,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['desc'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == i ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Get.offAllNamed('/'),
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Get.offAllNamed('/');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage < pages.length - 1 ? "Next" : "Get Started",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
}
