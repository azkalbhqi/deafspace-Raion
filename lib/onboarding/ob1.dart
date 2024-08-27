import 'package:deafspace_prod/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deafspace_prod/pages/login/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final PageController _controller = PageController();

  final List<String> _titles = [
    "Selamat datang! DeafSpace!",
    "Ini title ke 2",
    "Ini title ke 3",
    "Ini title ke 4",
  ];

  final List<String> _descriptions = [
    "Lorem ipsum 1 dolor sit amet, consectetur adipiscing elit.",
    "Lorem ipsum 2 dolor sit amet, consectetur adipiscing elit.",
    "Lorem ipsum 3 dolor sit amet, consectetur adipiscing elit.",
    "Lorem ipsum 4 dolor sit amet, consectetur adipiscing elit.",
  ];

  final List<String> _images = [
    'assets/images/img/1.png',
    'assets/images/img/2.png',
    'assets/images/img/3.png',
    'assets/images/img/4.png',
  ];

  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void _goToNextPage() {
    if (_currentIndex < _titles.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _skipOnboarding();  // Navigate to the next page after the last onboarding screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _titles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _images[index], // Ensure these paths are correct
                            height: 300, // Adjust as needed
                          ),
                          const SizedBox(height: 40),
                          TitleParagraph(
                            title: _titles[index],
                            description: _descriptions[index],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              TimelineAndNextButton(
                controller: _controller,
                currentIndex: _currentIndex,
                length: _titles.length,
                onNext: _goToNextPage,
              ),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                "Lewati",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: ColorStyles.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleParagraph extends StatelessWidget {
  final String title;
  final String description;

  const TitleParagraph({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          description,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class TimelineAndNextButton extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final int length;
  final VoidCallback onNext;

  const TimelineAndNextButton({
    Key? key,
    required this.controller,
    required this.currentIndex,
    required this.length,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: currentIndex == index ? 15 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index ? ColorStyles.primary : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              backgroundColor: ColorStyles.primary,
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
