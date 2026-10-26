import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/simulation_service.dart';
import '../core/constants/app_colors.dart';

class SimulationBanner extends StatelessWidget {
  const SimulationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SimulationService>(
      builder: (context, sim, child) {
        final isRunning = sim.isSimulating;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.accentMint,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryDarkGreen.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.developer_board,
                color: AppColors.primaryDarkGreen,
                size: 26,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'SIMULATION MODE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primaryDarkGreen,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isRunning ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'No ESP32 connected • Readings generated locally',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isRunning ? 'Pause simulation' : 'Resume simulation',
                icon: Icon(
                  isRunning
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: AppColors.primaryDarkGreen,
                  size: 28,
                ),
                onPressed: () {
                  sim.toggleSimulation();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
