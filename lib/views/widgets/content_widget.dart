import 'package:flutter/material.dart';
import 'package:weather_app/views/models/weather_models.dart';
import 'package:weather_app/views/widgets/top_content_widget.dart';
import 'package:weather_app/views/widgets/bottom_content_widget.dart';

class ContentWidget extends StatelessWidget {
  final WeatherData currentData;
  final PageController pageController;
  final int currentPage;
  final int totalPages;
  final VoidCallback onAdded;
  final Future<void> Function(String) onDelete;

  const ContentWidget({
    super.key,
    required this.currentData,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
    required this.onAdded,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -500) {
          if (currentPage < totalPages - 1 && pageController.hasClients) {
            pageController.animateToPage(
              currentPage + 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
        else if (details.primaryVelocity != null &&
            details.primaryVelocity! > 500) {
          if (currentPage > 0 && pageController.hasClients) {
            pageController.animateToPage(
              currentPage - 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TopContentWidget(
                weather: currentData.weather,
                disable: currentPage != 0,
                city: currentData.cityName,
                onAdded: onAdded,
                isSaved: currentData.savedJson != null,
                savedJson: currentData.savedJson,
                onDelete: (s) async => await onDelete(s),
              ),

              // PageView ẩn để giữ logic state
              SizedBox(
                height: 0,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: totalPages,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => const SizedBox.shrink(),
                ),
              ),

              const Spacer(),

              BottomContentWidget(weather: currentData.weather),

              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (i) {
                      final isActive = i == currentPage;
                      return GestureDetector(
                        onTap: () {
                          if (pageController.hasClients) {
                            pageController.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Icon(
                            isActive ? Icons.star : Icons.circle,
                            size: isActive ? 14 : 8,
                            color: isActive ? Colors.white : Colors.white70,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
