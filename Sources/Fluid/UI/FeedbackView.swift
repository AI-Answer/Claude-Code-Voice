//
//  FeedbackView.swift
//  fluid
//
//  Extracted from ContentView.swift to reduce monolithic architecture.
//  Created: 2025-12-14
//

import AppKit
import SwiftUI

struct FeedbackView: View {
    @Environment(\.theme) private var theme

    // MARK: - State Variables (moved from ContentView)

    @State private var feedbackText: String = ""
    @State private var feedbackEmail: String = ""
    @State private var includeDebugLogs: Bool = false
    @State private var isSendingFeedback: Bool = false
    @State private var showFeedbackConfirmation: Bool = false
    @State private var showFeedbackError: Bool = false
    @State private var feedbackErrorMessage: String = ""
    @State private var appear: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(self.theme.palette.accent)
                        VStack(alignment: .leading) {
                            Text("Send Feedback")
                                .font(.system(size: 28, weight: .bold))
                            Text("Help us improve Claude Code Voice")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.bottom, 8)

                // Friendly Message & GitHub CTA
                ThemedCard(style: .prominent, hoverEffect: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.pink)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("We'd love to hear from you!")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(self.theme.palette.primaryText)

                                Text("Your feedback helps us make Claude Code Voice even better")
                                    .font(.system(size: 14))
                                    .foregroundStyle(self.theme.palette.secondaryText)
                            }
                        }

                        Divider()
                            .padding(.vertical, 4)

                        HStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.yellow)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Loving Claude Code Voice?")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(self.theme.palette.primaryText)

                                Text("Give us a star on GitHub, or file an issue to help make Claude Code dictation even better.")
                                    .font(.system(size: 13))
                                    .foregroundStyle(self.theme.palette.secondaryText)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()

                            HStack(spacing: 10) {
                                if let githubURL = URL(string: "https://github.com/AI-Answer/Claude-Code-Voice") {
                                    Link(destination: githubURL) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "star.fill")
                                            Text("Star on GitHub")
                                                .fontWeight(.semibold)
                                        }
                                        .font(.system(size: 14))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                    }
                                    .fluidButton(.glass, size: .medium)
                                    .buttonHoverEffect()
                                }

                                if let issuesURL = URL(string: "https://github.com/AI-Answer/Claude-Code-Voice/issues") {
                                    Link(destination: issuesURL) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "ladybug.fill")
                                            Text("Open Issues")
                                                .fontWeight(.semibold)
                                        }
                                        .font(.system(size: 14))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                    }
                                    .fluidButton(.glass, size: .medium)
                                    .buttonHoverEffect()
                                    .help("Open the AI Answer issue tracker")
                                }
                            }
                        }
                    }
                    .padding(20)
                }

                // Feedback Form
                ThemedCard(style: .standard, hoverEffect: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Email")
                                .font(.headline)
                                .fontWeight(.semibold)

                            TextField("your.email@example.com", text: self.$feedbackEmail)
                                .textFieldStyle(.roundedBorder)
                                .font(.system(size: 14))

                            Text("Feedback")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.top, 8)

                            TextEditor(text: self.$feedbackText)
                                .font(.system(size: 14))
                                .frame(height: 120)
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 8)
                                    .fill(self.theme.palette.contentBackground)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(self.theme.palette.cardBorder.opacity(0.45), lineWidth: 1.2)))
                                .scrollContentBackground(.hidden)
                                .overlay(
                                    Group {
                                        if self.feedbackText.isEmpty {
                                            Text("Share your thoughts, report bugs, or suggest features...")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                                .padding(.leading, 4)
                                        }
                                    }
                                    .allowsHitTesting(false)
                                )

                            // Debug logs option
                            Toggle("Include debug logs", isOn: self.$includeDebugLogs)
                                .toggleStyle(GlassToggleStyle())

                            // Send Button
                            HStack {
                                Spacer()

                                Button(action: {
                                    Task {
                                        await self.sendFeedback()
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        if self.isSendingFeedback {
                                            ProgressView()
                                                .fixedSize()
                                                .scaleEffect(0.8)
                                        } else {
                                            Image(systemName: "paperplane.fill")
                                        }
                                        Text(self.isSendingFeedback ? "Opening..." : "Open GitHub Issue")
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                }
                                .fluidButton(.glass, size: .medium)
                                .disabled(self.feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                    self.feedbackEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                    self.isSendingFeedback)
                                .buttonHoverEffect()
                            }
                        }
                    }
                    .padding(20)
                }
                .modifier(CardAppearAnimation(delay: 0.1, appear: self.$appear))
            }
            .padding(24)
        }
        .onAppear {
            self.appear = true
        }
        .alert("Feedback Draft Opened", isPresented: self.$showFeedbackConfirmation) {
            Button("OK") {}
        } message: {
            Text("We opened a GitHub issue draft with your feedback. Review it before publishing, especially if logs are included.")
        }
        .alert("Feedback Draft Failed", isPresented: self.$showFeedbackError) {
            Button("Try Again") {
                Task {
                    await self.sendFeedback()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(self.feedbackErrorMessage)
        }
    }

    // MARK: - Feedback Functions

    private func sendFeedback() async {
        guard !self.feedbackEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !self.feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return
        }

        await MainActor.run {
            self.isSendingFeedback = true
        }

        let feedbackData = self.createFeedbackData()
        let success = await submitFeedback(data: feedbackData)

        await MainActor.run {
            self.isSendingFeedback = false
            if success {
                // Show confirmation and clear form
                self.showFeedbackConfirmation = true
                self.feedbackText = ""
                self.feedbackEmail = ""
                self.includeDebugLogs = false
            } else {
                // Show error to user - inputs are preserved for retry
                self.feedbackErrorMessage = "We couldn't open a GitHub issue draft. Please copy your feedback and file it at https://github.com/AI-Answer/Claude-Code-Voice/issues."
                self.showFeedbackError = true
            }
        }
    }

    private func createFeedbackData() -> [String: Any] {
        var feedbackContent = self.feedbackText.trimmingCharacters(in: .whitespacesAndNewlines)

        if self.includeDebugLogs {
            feedbackContent += "\n\n--- Debug Information ---\n"
            feedbackContent += "App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")\n"
            feedbackContent += "Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown")\n"
            feedbackContent += "macOS Version: \(ProcessInfo.processInfo.operatingSystemVersionString)\n"
            feedbackContent += "Date: \(Date().formatted())\n\n"

            // Add recent log entries
            let logFileURL = FileLogger.shared.currentLogFileURL()
            if FileManager.default.fileExists(atPath: logFileURL.path) {
                do {
                    let logContent = try String(contentsOf: logFileURL)
                    let lines = logContent.components(separatedBy: .newlines)
                    let recentLines = Array(lines.suffix(30)) // Last 30 lines
                    feedbackContent += "Recent Log Entries:\n"
                    feedbackContent += recentLines.joined(separator: "\n")
                } catch {
                    feedbackContent += "Could not read log file: \(error.localizedDescription)\n"
                }
            }
        }

        return [
            "email_id": self.feedbackEmail.trimmingCharacters(in: .whitespacesAndNewlines),
            "feedback": feedbackContent,
        ]
    }

    private func submitFeedback(data: [String: Any]) async -> Bool {
        let email = (data["email_id"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let feedback = (data["feedback"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        var body = feedback
        if !email.isEmpty {
            body += "\n\nReporter email: \(email)"
        }

        var components = URLComponents(string: "https://github.com/AI-Answer/Claude-Code-Voice/issues/new")
        components?.queryItems = [
            URLQueryItem(name: "title", value: "Feedback: Claude Code Voice"),
            URLQueryItem(name: "body", value: body),
        ]

        guard let url = components?.url else {
            DebugLogger.shared.error("Invalid GitHub issue URL", source: "FeedbackView")
            return false
        }

        await MainActor.run {
            NSWorkspace.shared.open(url)
        }
        DebugLogger.shared.info("Opened GitHub issue draft for feedback", source: "FeedbackView")
        return true
    }
}

#Preview {
    FeedbackView()
}
