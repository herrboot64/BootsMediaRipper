# API Documentation

Base URL examples:

- http://home-server.local:8787
- http://tailscale-device:8787

## Authentication

Prototype versions used a shared PIN. The portfolio roadmap moves toward API-key based client profiles.

Recommended header example:

Authorization: Bearer bmr_demo_xxxxxxxxx

## Planned endpoints

- GET /api/health
- GET /api/media/search
- GET /api/media/{id}
- POST /api/rip/screenshot
- POST /api/rip/video
- POST /api/rip/audio
- GET /api/jobs/{jobId}
- GET /api/output/recent
- POST /api/clients
- GET /api/clients
- DELETE /api/clients/{clientId}
