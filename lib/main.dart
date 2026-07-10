import 'dart:async';
import 'package:flutter/material.dart';

// ==========================================

// ==========================================
class Question {
  String questionText;
  List<String> options;
  int correctOptionIndex;

  Question(
      {required this.questionText,
      required this.options,
      required this.correctOptionIndex});
}

class ExamResult {
  int score;
  int totalQuestions;
  String date;
  double get percentage => (score / totalQuestions) * 100;
  bool get isPassed => percentage >= 50.0; // 50% is passing mark

  ExamResult(
      {required this.score, required this.totalQuestions, required this.date});
}

// ==========================================
List<Question> globalQuizzes = [];
List<ExamResult> globalHistory = [];

// ==========================================
// 3. Main App Entry
// ==========================================
void main() {
  runApp(const ImpressiveQuizApp());
}

class ImpressiveQuizApp extends StatelessWidget {
  const ImpressiveQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduQuiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        fontFamily: 'Roboto', // Default clean font
      ),
      home: const DashboardScreen(),
    );
  }
}

// ==========================================
// 4. Dashboard (Home Screen)
// ==========================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.quiz_rounded, size: 80, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  'EduQuiz',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 40),

                // Live Stats Card
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                            'Quizzes',
                            globalQuizzes.length.toString(),
                            Icons.library_books),
                        Container(
                            height: 50, width: 2, color: Colors.grey.shade300),
                        _buildStatColumn('Attempts',
                            globalHistory.length.toString(), Icons.history),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Admin Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings, size: 28),
                  label:
                      const Text('Admin Panel', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AdminScreen()))
                        .then((_) => _refresh());
                  },
                ),
                const SizedBox(height: 20),

                // Student Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.school, size: 28),
                  label: const Text('Student Panel',
                      style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const StudentScreen()))
                        .then((_) => _refresh());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.indigo, size: 30),
        const SizedBox(height: 8),
        Text(count,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo)),
        Text(title,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ==========================================
// 5. Admin Screen (Add & Manage Quizzes)
// ==========================================
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _questionCtrl = TextEditingController();
  final List<TextEditingController> _optionCtrls =
      List.generate(4, (_) => TextEditingController());
  int _correctIndex = 0;

  void _saveQuestion() {
    if (_questionCtrl.text.trim().isEmpty ||
        _optionCtrls.any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all fields properly!'),
          backgroundColor: Colors.red));
      return;
    }

    globalQuizzes.add(Question(
      questionText: _questionCtrl.text.trim(),
      options: _optionCtrls.map((c) => c.text.trim()).toList(),
      correctOptionIndex: _correctIndex,
    ));

    _questionCtrl.clear();
    for (var c in _optionCtrls) {
      c.clear();
    }
    setState(() {
      _correctIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Question Added Successfully!'),
        backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Admin Panel'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create New Question',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo)),
            const SizedBox(height: 15),
            TextField(
              controller: _questionCtrl,
              decoration: InputDecoration(
                  labelText: 'Question Text',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              maxLines: 2,
            ),
            const SizedBox(height: 15),
            ...List.generate(
                4,
                (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: _optionCtrls[index],
                        decoration: InputDecoration(
                          labelText:
                              'Option ${String.fromCharCode(65 + index)}',
                          prefixIcon: const Icon(Icons.radio_button_unchecked),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    )),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Correct Answer: ',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _correctIndex,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    items: List.generate(
                        4,
                        (index) => DropdownMenuItem(
                            value: index,
                            child: Text(
                                'Option ${String.fromCharCode(65 + index)}'))),
                    onChanged: (val) => setState(() => _correctIndex = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_task),
                label:
                    const Text('Save Question', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15)),
                onPressed: _saveQuestion,
              ),
            ),
            const Divider(height: 40, thickness: 2),
            const Text('Manage Questions',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo)),
            const SizedBox(height: 10),
            globalQuizzes.isEmpty
                ? const Center(child: Text('No questions added yet.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: globalQuizzes.length,
                    itemBuilder: (context, index) {
                      var q = globalQuizzes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: Text('${index + 1}',
                                  style: const TextStyle(color: Colors.white))),
                          title: Text(q.questionText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Ans: ${q.options[q.correctOptionIndex]}',
                              style: const TextStyle(color: Colors.green)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () =>
                                setState(() => globalQuizzes.removeAt(index)),
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 6. Student Screen (Exam Portal & History)
// ==========================================
class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Student Portal'),
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  const Icon(Icons.assignment, size: 50, color: Colors.orange),
                  const SizedBox(height: 10),
                  Text('Total Questions: ${globalQuizzes.length}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          globalQuizzes.isEmpty ? Colors.grey : Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: globalQuizzes.isEmpty
                        ? null
                        : () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ActiveExamScreen()));
                          },
                    child: const Text('START EXAM NOW',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Your Exam Records',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: globalHistory.isEmpty
                  ? const Center(
                      child: Text('You have not taken any exams yet.',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: globalHistory.length,
                      itemBuilder: (context, index) {
                        var res = globalHistory[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: res.isPassed
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              child: Icon(
                                  res.isPassed ? Icons.check : Icons.close,
                                  color:
                                      res.isPassed ? Colors.green : Colors.red),
                            ),
                            title: Text(
                                'Score: ${res.score} / ${res.totalQuestions}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            subtitle: Text(res.date),
                            trailing: Text(
                              res.isPassed ? 'PASSED' : 'FAILED',
                              style: TextStyle(
                                  color:
                                      res.isPassed ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 7. Active Exam Screen (With Timer)
// ==========================================
class ActiveExamScreen extends StatefulWidget {
  const ActiveExamScreen({super.key});

  @override
  State<ActiveExamScreen> createState() => _ActiveExamScreenState();
}

class _ActiveExamScreenState extends State<ActiveExamScreen> {
  int _currentIndex = 0;
  int _score = 0;
  Timer? _timer;
  int _timeLeft = 15; // 15 seconds per question

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _submitAnswer(-1); // Timeout means wrong answer
      }
    });
  }

  void _submitAnswer(int selectedIndex) {
    if (selectedIndex == globalQuizzes[_currentIndex].correctOptionIndex) {
      _score++;
    }

    if (_currentIndex < globalQuizzes.length - 1) {
      setState(() => _currentIndex++);
      _startTimer();
    } else {
      _timer?.cancel();
      _finishExam();
    }
  }

  void _finishExam() {
    var result = ExamResult(
      score: _score,
      totalQuestions: globalQuizzes.length,
      date: DateTime.now().toString().substring(0, 16),
    );
    globalHistory.add(result);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => ResultScreen(result: result)));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var q = globalQuizzes[_currentIndex];
    double progress = (_currentIndex + 1) / globalQuizzes.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam in Progress'),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false, // Prevent cheating/going back
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${_currentIndex + 1} of ${globalQuizzes.length}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.red),
                    const SizedBox(width: 5),
                    Text('00:${_timeLeft.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                color: Colors.orange,
                backgroundColor: Colors.orange.shade100),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
                  ]),
              child: Text(q.questionText,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
            ...List.generate(
                4,
                (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: Colors.black87,
                          alignment: Alignment.centerLeft,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _submitAnswer(index),
                        child: Text(
                            '${String.fromCharCode(65 + index)}.  ${q.options[index]}',
                            style: const TextStyle(fontSize: 16)),
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 8. Result Screen (Impressive Summary)
// ==========================================
class ResultScreen extends StatelessWidget {
  final ExamResult result;
  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          result.isPassed ? Colors.green.shade50 : Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                result.isPassed
                    ? Icons.emoji_events
                    : Icons.sentiment_dissatisfied,
                size: 100,
                color: result.isPassed ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                result.isPassed ? 'Congratulations!' : 'Keep Trying!',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: result.isPassed ? Colors.green : Colors.red),
              ),
              const SizedBox(height: 10),
              Text(
                'You scored ${result.score} out of ${result.totalQuestions}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),

              // Percentage Circle
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: result.percentage / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade300,
                      color: result.isPassed ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    '${result.percentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  )
                ],
              ),

              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Back to Dashboard'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.pop(context); // Go back to student panel
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
