# 🔧 Fix Visual Studio Build Lock Issue

## 🐛 Problem

Visual Studio cannot delete/rebuild files because they are locked by a process.

**Error:**
```
Unable to delete file "...\bin\roslyn\System.ValueTuple.dll"
Access to the path is denied. The file is locked by process (6404)
```

---

## ✅ Quick Fixes (Try in Order)

### Fix 1: Clean and Rebuild ⚡ (Fastest)
1. In Visual Studio menu: **Build → Clean Solution**
2. Close Visual Studio completely
3. Reopen Visual Studio
4. **Build → Rebuild Solution**

### Fix 2: Close IIS Express / Development Server 🔄
1. In system tray (bottom-right), find **IIS Express icon**
2. Right-click → **Exit**
3. Or open Task Manager (Ctrl+Shift+Esc)
4. Find **IISExpress.exe** → End Task
5. Try building again

### Fix 3: Delete bin and obj Folders 🗑️
1. Close Visual Studio
2. Navigate to project folder:
   ```
   C:\Users\hp\Music\jubba_clinic-main\jubba_clinic-main\juba_hospital\juba_hospital\
   ```
3. Delete these folders:
   - `bin`
   - `obj`
4. Reopen Visual Studio
5. **Build → Rebuild Solution**

### Fix 4: Kill Locked Processes 💀
1. Open **Task Manager** (Ctrl+Shift+Esc)
2. Go to **Details** tab
3. Find and End Task for:
   - `IISExpress.exe`
   - `w3wp.exe`
   - `VBCSCompiler.exe`
   - `MSBuild.exe`
4. Try building again

### Fix 5: Restart Visual Studio 🔄
1. Close Visual Studio completely
2. Open **Task Manager**
3. Make sure no Visual Studio processes are running:
   - `devenv.exe`
   - `ServiceHub.*`
4. Reopen Visual Studio
5. Build again

### Fix 6: Restart Computer 🖥️ (Last Resort)
If all else fails, restart your computer to clear all locked processes.

---

## 🚀 PowerShell Script (Advanced)

Run this in PowerShell as Administrator to clean and unlock:

```powershell
# Stop IIS Express
Stop-Process -Name "iisexpress" -Force -ErrorAction SilentlyContinue

# Stop build processes
Stop-Process -Name "VBCSCompiler" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "MSBuild" -Force -ErrorAction SilentlyContinue

# Navigate to project
cd "C:\Users\hp\Music\jubba_clinic-main\jubba_clinic-main\juba_hospital\juba_hospital\"

# Delete bin and obj
Remove-Item -Path "bin" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "obj" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Cleaned! Now open Visual Studio and rebuild."
```

---

## 🎯 Prevention Tips

### 1. Always Stop Debugging Before Building
- Press **Shift+F5** to stop debugging
- Wait a few seconds before rebuilding

### 2. Use Clean Instead of Rebuild First
- **Build → Clean Solution**
- Then **Build → Build Solution**

### 3. Close Browser Windows
- Close all browser windows running the application
- This releases file locks

### 4. Disable Antivirus Temporarily
- Sometimes antivirus locks files
- Add Visual Studio folder to exclusions

---

## ⚡ Fastest Solution for Your Case

Since the error shows process ID **6404**, try this:

1. Open **Task Manager** (Ctrl+Shift+Esc)
2. Go to **Details** tab
3. Find process with PID **6404**
4. Right-click → **End Task**
5. Try building again

---

## 🔍 Why This Happens

**Common Causes:**
1. IIS Express still running after stopping debugger
2. File watcher (like nodemon, webpack) locking files
3. Antivirus scanning files during build
4. Previous build process didn't close properly
5. Multiple Visual Studio instances open

---

## ✅ Recommended Workflow

To avoid this issue in the future:

1. **Stop Debugging** (Shift+F5)
2. **Wait 2-3 seconds**
3. **Close browser windows**
4. **Build → Clean Solution**
5. **Build → Build Solution**

---

**Status:** This is a temporary lock issue  
**Impact:** Doesn't affect your code  
**Solution:** One of the fixes above will work  
**Most Common Fix:** Close IIS Express from system tray
