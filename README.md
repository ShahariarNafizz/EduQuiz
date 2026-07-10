# 📱 EduQuiz - Flutter Quiz Application

## 📖 Project Overview
This is a modern, responsive, and feature-rich Quiz Application built with **Flutter**. The project is divided into two main sections: an **Admin Panel** for managing quizzes and a **Student Panel** for participating in exams. 

This project was developed and tested on [FlutLab.io](https://flutlab.io/) as a web-based Flutter project.

## ✨ Features
### 👨‍💻 Admin Panel
* Add new Multiple Choice Questions (MCQs) with 4 options.
* Set the correct answer via a dropdown menu.
* View and manage the list of all existing questions.

### 🎓 Student Panel
* **Live Dashboard:** Displays total quizzes available and recent exam attempts.
* **Interactive Exam Screen:** Features a **25-second circular timer** for each question.
* **Auto-Skip Logic:** If the timer runs out, it automatically marks the question as skipped/wrong and jumps to the next one.
* **Beautiful Result Screen:** Displays the total score, calculated percentage, and a **Pass/Fail** status (50% passing criteria) with an elegant UI.

## 🛠️ Technical Details & Architecture
* **Framework:** Flutter / Dart
* **Architecture:** Clean UI with Object-Oriented Programming (OOP) Models (`Question` and `ExamResult` classes).
* **Database Logic (Important Note for Sir):** 
  * The initial project requirement was to use **SQLite/Local Storage**. However, because this project was developed and compiled entirely on **FlutLab.io's Web Simulator**, native SQLite (which requires native Android/iOS file systems) is not supported in the web environment. 
  * To ensure a 100% crash-free, smooth, and functional experience on the web IDE, I implemented an **In-Memory Database using Global Lists & OOP concepts**. This handles the entire logic of saving questions and generating histories dynamically without relying on heavy third-party packages that cause web compilers to crash.

## 🚀 How to Run the Project
Since this project uses core Flutter widgets with zero external package dependencies, running it is extremely simple:

### Option 1: Running on FlutLab.io (Web IDE)
1. Open [FlutLab.io](https://flutlab.io/) and create a new Flutter project.
2. Replace the contents of `lib/main.dart` with the `main.dart` code from this repository.
3. Update the `pubspec.yaml` file (only requires standard flutter sdk and cupertino_icons).
4. Click the **Run / Build** button on the right panel.

### Option 2: Running Locally (VS Code / Android Studio)
1. Clone this repository: 
   ```bash
   git clone [https://github.com/ShahariarNafizz/EduQuiz.git](https://github.com/ShahariarNafizz/EduQuiz.git)
