import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> leaders = [
      {'name': 'Daniella', 'score': 980, 'avatar': 'D'},
      {'name': 'Marcel', 'score': 920, 'avatar': 'M'},
      {'name': 'Theodore', 'score': 875, 'avatar': 'T'},
      {'name': 'Wayne', 'score': 840, 'avatar': 'W'},
      {'name': 'Brian', 'score': 790, 'avatar': 'B'},
      {'name': 'Alice', 'score': 750, 'avatar': 'A'},
      {'name': 'John', 'score': 700, 'avatar': 'J'},
    ];

    final colors = [Colors.amber, Colors.grey, Colors.brown];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Leaderboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top 3
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd place
                _TopCard(
                  leader: leaders[1],
                  rank: 2,
                  color: Colors.grey,
                  height: 100,
                ),
                // 1st place
                _TopCard(
                  leader: leaders[0],
                  rank: 1,
                  color: Colors.amber,
                  height: 130,
                ),
                // 3rd place
                _TopCard(
                  leader: leaders[2],
                  rank: 3,
                  color: Colors.brown,
                  height: 80,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Rest of list
            ...List.generate(leaders.length - 3, (i) {
              final leader = leaders[i + 3];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "#${i + 4}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      child: Text(
                        leader['avatar'] as String,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      leader['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      "${leader['score']} pts",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  final Map<String, dynamic> leader;
  final int rank;
  final Color color;
  final double height;

  const _TopCard({
    required this.leader,
    required this.rank,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.emoji_events, color: color, size: 28),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.15),
          child: Text(
            leader['avatar'] as String,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          leader['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          "${leader['score']} pts",
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              "#$rank",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
