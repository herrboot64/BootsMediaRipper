# Boots Media Ripper

Boots Media Ripper is a local-first Windows and Android media utility for searching a home media library and extracting screenshots, video clips, or MP3/audio clips at exact timestamps.

This project started as a real personal workflow tool and is being polished into a public portfolio project. It demonstrates practical AI-assisted app development, local API design, Windows automation, Android client workflows, ffmpeg integration, documentation, security hygiene, and repeatable project structure.

Public repo rule: this repository must never contain real API keys, real PINs, private media inventories, SMB credentials, private IPs, Tailscale hostnames, logs, generated clips, APKs, or personal config files.

## Features

- Windows tray and server app
- Browser UI
- Local HTTP API
- ffmpeg screenshot extraction
- ffmpeg video clip extraction
- ffmpeg MP3/audio clip extraction
- Searchable media inventory
- Clean timestamp and filename handling
- Organized output folders
- Logging and troubleshooting support
- Android companion client
- Home LAN and private network fallback design
- Planned API-key based client profiles
- Planned importable bmrinvite client profiles

## Repository structure

- server-windows: public-safe server references, assets, and future source files
- android-client: Android companion client area
- tools: setup and maintenance scripts
- docs: case study, API docs, changelog, roadmap, security, screenshots
- samples: sanitized sample configs and demo data

## Safe placeholders

- http://home-server.local:8787
- http://tailscale-device:8787
- bmr_demo_xxxxxxxxx
- \\MEDIA-SERVER\Movies
- \\MEDIA-SERVER\tv

## Screenshots

Public-safe screenshots should be placed in docs/screenshots.

## Status

This repo is being structured for GitHub publication.
