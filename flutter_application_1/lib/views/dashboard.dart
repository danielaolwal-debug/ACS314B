import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Planner Dashboard"),
        backgroundColor: const Color.fromARGB(255, 114, 147, 134),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1522202176988-66273c2fd55f",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 21, 113, 71),
                const Color.fromARGB(255, 254, 250, 254),
                const Color.fromARGB(255, 21, 113, 71),
                const Color.fromARGB(255, 254, 250, 254),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Today's Study Tasks",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.book),
                          title: const Text("Read Chapter 2"),
                          subtitle: const Text("History"),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.code),
                          title: const Text("Practice Flutter"),
                          subtitle: const Text("Programming"),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.calculate),
                          title: const Text("Solve Math Exercises"),
                          subtitle: const Text("Mathematics"),
                        ),
                      ),
                    ],
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
