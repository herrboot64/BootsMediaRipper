Boot's Media Ripper Server - Tray MVP

Target: BOOT-MSI / home-server.local
URL: http://home-server.local:8787/
Default PIN: 1234

This is a tray-only server. It should not create a normal taskbar window.

First-time setup on the MSI:
1. Extract this folder.
2. Confirm ffmpeg works: ffmpeg -version
3. Run PowerShell as Administrator in this folder.
4. Run: powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Setup-BMR-Server-RunAsAdmin.ps1
5. Double-click BootsMediaRipperServer.exe
6. Use the tray icon or open http://home-server.local:8787/
7. Click Update New Media before first use.

Outputs:
OUTPUT\Screenshots
OUTPUT\Video Clips
OUTPUT\Audio Clips

Internal files:
.assets
Change PIN/server settings:
.assets\server_config.json


Launcher V2 Notes
-----------------
If BootsMediaRipperServer.exe does not start the server, use:
  Launch Boot's Media Ripper Server Hidden.vbs

That VBS launcher starts the exact same PowerShell tray server hidden with:
  -STA -WindowStyle Hidden

For troubleshooting, use:
  Launch Server DEBUG Visible.cmd

If the visible debug launcher opens the web UI/server correctly, the server script is good and only the launcher path needs attention.


Process Fix Build
-----------------
This build does NOT use Start-Job for the HTTP listener.

Tray host:
  .assets\BootsMediaRipperServer.ps1

HTTP listener process:
  .assets\BootsMediaRipperHttpServer.ps1

PID file:
  .assets\server_http.pid

Logs:
  .assets\server_tray.log
  .assets\server_http.log

If tray appears but web page refuses connection:
  1. Check netstat:
       netstat -ano | findstr :8787
  2. Check logs:
       Get-Content .\.assets\server_tray.log -Tail 80
       Get-Content .\.assets\server_http.log -Tail 80
  3. Run:
       Launch HTTP Server DEBUG Visible.cmd


Fixed Themed UI Build
---------------------
This build fixes the previous themed HTML PowerShell here-string syntax issue.

If tray starts but the page does not load:
  1. Run:
       Test HTTP Script Syntax.cmd
  2. Run:
       Launch HTTP Server DEBUG Visible.cmd
  3. Check:
       .assets\server_tray.log
       .assets\server_http.log

The themed hero image lives here:
  .assets\web\embyRipperHero.jpg

Shared PIN:
  .assets\server_config.json


Purple Auto-Download UI Tweaks
------------------------------
- Hero image is now shown cleanly without overlay text.
- Primary buttons use a purple theme.
- After a screenshot/video/MP3 is created, the browser attempts to trigger the download automatically.
- A "Download again" link remains as a fallback.


Feedback UI Fix
---------------
- Removed the purple text label below the hero image.
- Added a sticky visible status banner under the hero image.
- Search/rip/update buttons now immediately show visible working feedback.
- JavaScript functions were renamed to avoid browser/global name collisions.
- Errors are displayed in the page instead of leaving the browser feeling dead.
- Downloads still auto-trigger after successful creation, with a Download again fallback link.


JavaScript Literal Fix
----------------------
This build changes the browser UI HTML to a literal PowerShell here-string so PowerShell cannot mangle JavaScript.

Expected page status after refresh:
  Ready. UI script loaded.

If it only says:
  Ready.

then the browser is showing a cached old page. Hard refresh with Ctrl+F5 or close/reopen the browser tab.

What changed:
- No inline onclick handlers.
- Buttons are wired with addEventListener.
- No JavaScript template literals.
- No PowerShell interpolation inside the HTML block.


New Emby Ripper Icon + Mobile Polish
------------------------------------
This build replaces the old app icon with the new Boot's Emby Ripper artwork.

Installed icon files:
  .assets\bmrIcon.ico
  .assets\embyRipperIcon.png
  .assets\web\icon-192.png
  .assets\web\icon-512.png

Web additions:
  /favicon.ico
  /manifest.webmanifest
  /assets/icon-192.png
  /assets/icon-512.png

Phone browser polish:
  - Smaller hero image on narrow screens
  - Full-width buttons on phones
  - Single-column layout on phones
  - Sticky status banner remains visible
  - Browser add-to-home-screen metadata included

EXE icon:
  Run this once from the app folder on Windows if the EXE still shows the generic icon:
    Apply EXE Icon.cmd


FFmpeg Runner Fix
-----------------
This build fixes PowerShell treating normal ffmpeg stderr/banner output as a web UI error.

Symptom fixed:
  ERROR: ffmpeg version 2025-... Copyright...

ffmpeg stdout/stderr is now captured into:
  .assets\last_ffmpeg_server_error.txt

The server now checks ffmpeg's exit code instead of failing on normal banner/progress text.


All-Red Theme Tweak
-------------------
Primary action buttons and update buttons now use the same red horror/grunge accent theme.

If your browser still shows purple after updating:
  Ctrl+F5
or close/reopen the tab.


Logs + FFmpeg Argument Fix
--------------------------
This build keeps the all-red theme and fixes the ffmpeg runner.

Changes:
  - Uses ProcessStartInfo with ArgumentList so ffmpeg receives arguments correctly.
  - Captures stdout and stderr into one log.
  - Moves server logs into:
      LOGS\
  - Tray menu now includes:
      Open LOGS Folder

Primary logs:
  LOGS\server_tray.log
  LOGS\server_http.log
  LOGS\last_ffmpeg_server_error.txt
  LOGS\inventory_log.txt
  LOGS\inventory_summary.txt

If ffmpeg fails, the web UI now says to check the LOGS folder and the log includes:
  ffmpeg path
  argument count
  full argument list
  stdout
  stderr
  exit code


Clean FFmpeg Error + Logs Fix
-----------------------------
This build keeps the all-red theme and makes ffmpeg failures readable.

Changes:
  - FFM calls now use explicit -FFmpegArgs arrays.
  - Browser no longer dumps the ffmpeg banner/usage block.
  - Full ffmpeg details go to LOGS\last_ffmpeg_server_error.txt.
  - Tray menu includes Open LOGS Folder.

Expected browser error now:
  ffmpeg failed with exit code 1. Open LOGS folder and check last_ffmpeg_server_error.txt

Then the LOGS file shows:
  argument count
  exact arguments
  command line
  stdout
  stderr
  exit code


SLEDGEHAMMER Build
------------------
If the browser still shows "Last log lines", you are running the old HTTP process/script.

This build/patch marks the web UI with:
  Build SLEDGEHAMMER-2026-05-16

It also marks the ffmpeg log with:
  BOOT EMBY RIPPER FFMPEG RUNNER BUILD: SLEDGEHAMMER-2026-05-16

Use SLEDGEHAMMER-Patch-BMR-Server.ps1 if replacing files does not take.


NUCLEAR Local FFmpeg Build
--------------------------
This build stops relying on the system/TDARR ffmpeg first.

Use this first:
  Setup Local FFmpeg.cmd

It downloads a private ffmpeg here:
  .tools\ffmpeg\bin\ffmpeg.exe

The HTTP server uses ffmpeg in this order:
  1. .tools\ffmpeg\bin\ffmpeg.exe
  2. ffmpeg.exe from PATH
  3. C:\ffmpeg\bin\ffmpeg.exe

Also added:
  Kill Stale BMR Processes.cmd
  Tray menu: Hard Restart / Kill Stale Workers
  Tray menu: Open LOGS Folder

Logs:
  LOGS\server_tray.log
  LOGS\server_http.log
  LOGS\last_ffmpeg_server_error.txt

Verify current build in browser status:
  Ready. UI script loaded. Build NUCLEAR-LOCALFFMPEG-2026-05-16.

Install order:
  1. Exit tray server.
  2. Extract/replace with this package.
  3. Run Kill Stale BMR Processes.cmd.
  4. Run Setup Local FFmpeg.cmd.
  5. Run BootsMediaRipperServer.exe.
  6. Ctrl+F5 browser.


UNC Path Fix
------------
This build fixes over-escaped Windows/UNC paths.

The bad command line looked like:
  "\\home-server.local\emby\Movies - 2\..."

For Windows command-line use, the path must remain:
  "\home-server.local\emby\Movies - 2\..."

Build marker:
  NUCLEAR-UNC-FIX-2026-05-16


Download PIN Fix
----------------
Screenshots/clips/MP3 creation sends the PIN with X-BMR-PIN.
Normal browser downloads from links cannot send custom headers.

This build appends:
  ?pin=<household PIN>

to generated download URLs so the browser download prompt works.

Build marker:
  NUCLEAR-DOWNLOAD-PIN-FIX-2026-05-16


Milliseconds Timestamp Support
------------------------------
This build supports millisecond timestamps for screenshots, clips, and MP3s.

Accepted timestamp examples:
  27:30
  27:30.500
  00:27:30.250
  1:05:10.750

Screenshot UI now includes nudge buttons:
  -1s
  -500ms
  -250ms
  -100ms
  +100ms
  +250ms
  +500ms
  +1s

Filename examples:
  Bride Of Chucky - 1998 - 27m30.500s.png
  Movie Name - 01h05m10.250s.mp4

Build marker:
  MILLISECONDS-2026-05-16


Favicon / Bookmark Icon Fix
---------------------------
This build adds stronger browser icon support:
  /favicon.ico
  /favicon.png
  /assets/icon-32.png
  /assets/icon-192.png
  /assets/icon-512.png
  /manifest.webmanifest

HTML icon tags are cache-busted with:
  FAVICON-FIX-2026-05-16

If Brave still shows a generic globe:
  1. Ctrl+F5 hard refresh.
  2. Remove/re-add the bookmark.
  3. Open these directly:
       http://home-server.local:8787/favicon.ico?v=FAVICON-FIX-2026-05-16
       http://home-server.local:8787/assets/icon-32.png?v=FAVICON-FIX-2026-05-16


Session + Recents Browser UI
----------------------------
This build makes the web UI behave more like a session console.

Changes:
  - Query, PIN, screenshot time, clip start/end auto-save locally in the browser.
  - Page restores your previous session on reload.
  - Recent sessions list is saved locally on that device/browser.
  - Save Current to Recents button.
  - Clear Recents button.
  - After screenshot/video/MP3, the page stays open and downloads using fetch/blob.
  - Download no longer navigates/blanks the app page.
  - Download Again link remains.

Build marker:
  SESSION-RECENTS-2026-05-16


Rollback Last Known Good - Clean Package
----------------------------------------
No patch scripts are included in this ZIP.

Purpose:
  Roll back away from the repeated time rename / seek parser changes.

Expected build marker:
  ROLLBACK-LAST-KNOWN-GOOD-2026-05-16

Tradeoff:
  This may bring back the older less-pretty timestamp filenames, but should restore the behavior from before the rename-fix spiral.

