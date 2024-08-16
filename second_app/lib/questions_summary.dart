import 'package:flutter/material.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary(this.summaryData, {super.key});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: summaryData.map((data) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.25), // border color
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2), // border width
                    child: Container(
                      alignment: Alignment.center,
                      // or ClipRRect if you need to clip the content
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data['user-answer'] as String ==
                                data['correct-answer'] as String
                            ? const Color.fromARGB(255, 100, 245, 105)
                            : const Color.fromARGB(
                                255, 238, 61, 37), // inner circle color
                      ),
                      child: Text(
                        ((data['question-index'] as int) + 1).toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // inner content
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["question"] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        data['user-answer'] as String,
                        style: TextStyle(
                          color: data['user-answer'] as String ==
                                  data['correct-answer'] as String
                              ? const Color.fromARGB(255, 100, 245, 105)
                              : const Color.fromARGB(255, 238, 61, 37),
                          decoration: data['user-answer'] as String ==
                                  data['correct-answer'] as String
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        data['correct-answer'] as String,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 100, 245, 105)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
