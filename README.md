# Claude Code Voice

AI Answer-branded macOS voice-to-text for Claude Code workflows.

> Forked from [altic-dev/FluidVoice](https://github.com/altic-dev/FluidVoice). This fork keeps the upstream GPLv3 license and attribution. It is an independent community build, not an official Anthropic product.

## What it does

Claude Code Voice lets you dictate into any macOS text field, including Claude Code, Cursor, Slack, Docs, Gmail, terminals, and browsers. It keeps the local-first FluidVoice foundation and adds AI Answer branding, repo links, and update/feedback destinations for the AI Answer fork.

## Status

- Repo: https://github.com/AI-Answer/Claude-Code-Voice
- Upstream: https://github.com/altic-dev/FluidVoice
- License: GPLv3
- Current fork baseline: FluidVoice 1.6.x
- Packaged release: not published yet. Build from source until AI Answer signs and uploads a release.

## Features

- Local-first dictation and transcription on macOS
- Global hotkey capture and direct text insertion
- Command Mode for voice-driven Mac actions
- Write Mode for composing or rewriting selected text
- Multiple speech engines: Nemotron, Parakeet, Cohere Transcribe, Apple Speech, and Whisper
- Optional AI enhancement with provider keys stored in macOS Keychain
- Audio history, local exports, beta update support, and rollback support

## Quick start from source

Requirements:

- macOS 15.0 Sequoia or later
- Xcode 26 or later recommended
- Microphone and Accessibility permissions

Build:

```bash
git clone https://github.com/AI-Answer/Claude-Code-Voice.git
cd Claude-Code-Voice
xcodebuild -project Fluid.xcodeproj -scheme FluidVoice -configuration Debug build
```

Open in Xcode:

```bash
open Fluid.xcodeproj
```

Then select the `FluidVoice` scheme, set signing to your Apple Developer team, and run.

## Release and update notes

The app's in-app update, release notes, bug report, and feedback links now point to the AI Answer fork:

- Issues: https://github.com/AI-Answer/Claude-Code-Voice/issues
- Releases: https://github.com/AI-Answer/Claude-Code-Voice/releases

Before shipping to users, AI Answer still needs to sign, notarize, publish a release asset, and optionally wire a dedicated feedback backend.

## Attribution

This project is a fork of FluidVoice by altic-dev. Original project:

- https://github.com/altic-dev/FluidVoice
- https://altic.dev/fluid

The original code and this fork are distributed under GPLv3. See [LICENSE](LICENSE) and [NOTICE.md](NOTICE.md).
