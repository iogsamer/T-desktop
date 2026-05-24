<p align="center">
  <img src="images/stremio.png" alt="DarkFlix" width="120"/>
</p>
<h1 align="center">🎬 DarkFlix Desktop</h1>
<p align="center">Freedom to Stream — Dark Orange Edition</p>

<p align="center">
  <img src="https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white"/>
  <img src="https://img.shields.io/badge/C++-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white"/>
  <img src="https://img.shields.io/badge/WebView2-0078D6?style=for-the-badge&logo=microsoftedge&logoColor=white"/>
  <img src="https://img.shields.io/badge/Theme-FF6A00?style=for-the-badge"/>
</p>

---

## ✨ Features

- 🟠 **Orange dark theme** throughout
- 🔐 **Google Sign-In** — no password needed
- 📺 **OpenSubtitles Pro** — Arabic subtitles (built-in)
- 🌊 **Torrentio** — quality-sorted streams (built-in)
- 🎞️ **4K MPV playback** with hardware decoding
- 💬 **Discord Rich Presence**
- 🔄 **Auto-updater**

---

## 📥 Download

Go to [**Releases**](../../releases/latest) and download:

| File | Description |
|------|-------------|
| `DarkFlix X.X.X-x64.exe` | Windows 64-bit Installer |
| `DarkFlix X.X.X-x86.exe` | Windows 32-bit Installer |

---

## 🔐 Google Sign-In Setup

1. Go to [console.cloud.google.com](https://console.cloud.google.com/)
2. New Project → **APIs & Services** → **Credentials**
3. Create **OAuth 2.0 Client ID** (Web application)
4. Add redirect URI: `http://127.0.0.1:11471/api/google/callback`
5. Set environment variables:
   ```powershell
   setx GOOGLE_CLIENT_ID "your-id.apps.googleusercontent.com"
   setx GOOGLE_CLIENT_SECRET "your-secret"
   ```

---

## 🏗️ Build from Source

Requires: **Windows**, Visual Studio 2022, CMake, Ninja

```powershell
git clone https://github.com/Project1155/T-desktop
cd T-desktop
# GitHub Actions handles the full build automatically
# Push a tag to trigger: git tag v5.0.21 && git push origin v5.0.21
```

---

## 🔑 Update Signing

The private key (`darkflix_private_key_KEEP_SECRET.pem`) signs the version manifest.
Keep it safe — never commit it. See `SIGNING.md` for details.
