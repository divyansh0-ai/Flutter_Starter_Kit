# 🚀 Liquid Galaxy Flutter Starter Kit

Welcome to the **Liquid Galaxy Flutter Starter Kit**! This project is designed to help you quickly build immersive, multi-screen applications for Liquid Galaxy with built-in Gemini AI integration.

## 🏗️ Project Structure

This project follows the "Agent-Hardened" structure from the Web Starter Kit:

- `lib/services/`: Core logic for SSH (LG) and AI (Gemini).
- `lib/providers/`: State management using Provider.
- `lib/screens/`: UI implementation.
- `.agent/`: Mentored development workflows (run via `/` commands).

## 🤖 Mentored Experience

We've included a 6-stage mentoring system to guide you:

1. **Initialize** (`/lg-init`): Setup your credentials.
2. **Brainstorm** (`/lg-brainstormer`): Design your "Wow-Factor".
3. **Plan** (`/lg-plan-writer`): Detail your implementation.
4. **Execute** (`/lg-exec`): Write and verify code.
5. **Review** (`/lg-code-reviewer`): Audit for quality.
6. **Quiz** (`/lg-quiz-master`): Test your knowledge.

## 🛠️ Key Features

- **SSH & SFTP**: Built-in support for sending KMLs and controlling the rig.
- **Gemini AI**: Integrated "Agent" that translates text queries into visual actions.
- **Multi-Screen Sync**: Ready-to-use KML templates for 3+ screen setups.
- **State Management**: Clean separation of concerns with Provider.

## 🏁 Getting Started

1. **Clone the repo.**
2. **Install Flutter Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Setup Environment**:
   Copy `.env.example` to `.env` and add your Liquid Galaxy and Gemini API keys.
4. **Run the App**:
   ```bash
   flutter run
   ```
   
---
*Built for the Gemini Summer of Code 2026 - Liquid Galaxy Project.*
*Fully compatible with GSoC 2026 rules and "Agent-Hardened" Liquid Galaxy architectures.*
