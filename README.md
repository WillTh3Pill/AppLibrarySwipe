# AppLibrarySwipe - ROOTLESS

For **Dopamine** and other **rootless** jailbreaks (iOS 15-16).

## 🚀 UPLOAD TO GITHUB

### Step 1: Create Repository
1. Go to https://github.com/new
2. Name: `AppLibrarySwipe`
3. **Public**
4. Click **Create repository**

### Step 2: Upload (Windows)
```cmd
cd C:\Users\Administrator\Desktop\rootless-repo

git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://YOUR-TOKEN@github.com/WillTh3Pill/AppLibrarySwipe.git
git push -u origin main
```

### Step 3: Get Your .deb
1. Go to https://github.com/WillTh3Pill/AppLibrarySwipe/actions
2. Click the green checkmark
3. Download **AppLibrarySwipe-Rootless** from Artifacts
4. Extract the .deb file

### Step 4: Install on Your Device
1. Transfer the .deb to your device
2. Open **Sileo** (comes with Dopamine)
3. Go to the .deb file in Filza
4. Tap it → Install
5. Respring

## 📱 Users Install Via Sileo

Since you're on rootless, users will:
1. Download the .deb from your GitHub Releases
2. Install via Sileo's "Install .deb" feature

**OR** you can add it to existing rootless repos like:
- Chariz
- Havoc
- dynastic

## What's Different?

✅ Uses `THEOS_PACKAGE_SCHEME=rootless` 
✅ Installs to `/var/jb/` instead of `/`
✅ Works with Dopamine, Palera1n (rootless mode)
✅ Compatible with Sileo (rootless package manager)

## NO Cydia/Zebra Repo Needed

For rootless, just share the .deb download link from GitHub Releases.
