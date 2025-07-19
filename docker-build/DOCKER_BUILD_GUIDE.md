# 🐳 Rayhunter Enhanced - Simple 3-Step Docker Build

This guide provides a **simple, modular approach** to building rayhunter-enhanced using Docker as a persistent build environment with GPS integration and USB device access.

## 🎯 **Simple 3-Step Process**

### **Step 1: Setup Build Environment** 📦
```bash
./setup_ubuntu_ci.sh
```
**What it does:**
- Installs Rust toolchain with ARM targets
- Installs Node.js and npm
- Installs Android SDK and adb
- Installs ARM cross-compilation tools
- Sets up build environment variables
- Configures GPS API endpoints

### **Step 2: Download Source Code** 📥
```bash
./fetch_source.sh
```
**What it does:**
- Clones latest rayhunter-enhanced from GitHub
- Updates existing repository if already present
- Verifies project structure
- Makes build scripts executable
- **Automatically patches project build scripts** to load build environment
- Creates backups of original scripts before patching

### **Step 3: Build and Deploy** 🚀
```bash
./build_and_deploy.sh
```
**What it does:**
- Builds the application for ARM targets
- Creates web interface assets
- Deploys to connected device via adb over USB
- Verifies deployment
- Includes GPS API endpoints and correlation features

## 🚀 **Quick Start**

### **1. Start Docker Environment**
```bash
./docker-build.sh up
./docker-build.sh shell
```

### **2. Run All Steps**
```bash
# Inside the container
./setup_ubuntu_ci.sh && ./fetch_source.sh && ./build_and_deploy.sh
```

### **3. Or Run Steps Individually**
```bash
# Step 1: Setup environment (run once)
./setup_ubuntu_ci.sh

# Step 2: Get latest source code
./fetch_source.sh

# Step 3: Build and deploy
./build_and_deploy.sh
```

## 📱 **GPS Integration Features**

### **GPS API Endpoints**
The enhanced version includes comprehensive GPS integration:

- ✅ **Real-time GPS coordinate submission** via REST API
- ✅ **Mobile app compatibility** (GPS2REST-Android)
- ✅ **Multiple export formats** (CSV, JSON, GPX)
- ✅ **Per-scan GPS files** with automatic timestamp correlation
- ✅ **External GPS device support** via API endpoints

### **GPS API Usage**
```bash
# Submit GPS coordinates (GET method - GPS2REST-Android compatible)
curl "http://192.168.1.1:8080/api/v1/gps/37.7749,-122.4194"

# Submit GPS coordinates (POST method)
curl -X POST "http://192.168.1.1:8080/api/v1/gps/37.7749,-122.4194"

# Download GPS data for a recording session
curl "http://192.168.1.1:8080/api/gps/1720080123/csv" -o gps_data.csv
```

### **GPS Data Integration**
- **Automatic correlation** with cellular captures
- **Location-based analysis** for cell tower mapping
- **Journey tracking** with GPS waypoints
- **Export capabilities** for external analysis tools

## 🔧 **USB Device Access**

### **Enhanced USB Support**
The Docker environment includes full USB device access:

```bash
# Start container with USB access
./docker-build.sh up

# If USB devices not accessible, restart with enhanced access
./restart_container_with_usb.sh

# Check USB device permissions
lsusb
# Should show your device

# Verify adb connection from container
adb devices
# Should show device as "device"
```

### **USB Troubleshooting**
If Docker container can't access USB devices:

```bash
# Restart container with enhanced USB access
./restart_container_with_usb.sh

# Check USB device permissions
lsusb
# Should show your device

# Verify adb connection from container
adb devices
# Should show device as "device"
```

## 🐛 **Cross-Compilation Fix (If Needed)**

If you encounter ARM linker errors like:
```
/usr/arm-linux-gnueabihf/bin/ld: unrecognised emulation mode: elf_x86_64
```

Apply this fix inside the Docker container:

```bash
# Navigate to the source directory
cd ~/rayhunter-enhanced

# Apply cross-compilation fix to build script
cat > fix_cross_compilation.sh << 'EOF'
#!/bin/bash

# Fix build_all.sh for proper cross-compilation
cp build_all.sh build_all.sh.backup

cat > build_all.sh << 'BUILDSCRIPT'
#!/bin/bash -e

# Comprehensive build script for rayhunter-enhanced
# This script builds all components in the correct order with proper cross-compilation

echo "🏗️  Building rayhunter-enhanced..."
echo "=====================================\n"

# Source build environment (local deps first, then system)
if [ -f "./build_deps/setup-env.sh" ]; then
    source "./build_deps/setup-env.sh"
    echo "✅ Local build environment loaded"
elif [ -f ~/.cargo/env ]; then
    source ~/.cargo/env
    echo "✅ System Rust environment loaded"
elif [ -f ~/.rayhunter_build_env ]; then
    source ~/.rayhunter_build_env
    echo "✅ Rayhunter build environment loaded"
else
    echo "⚠️  No build environment found!"
    echo "   Run ./setup_local_deps.sh for local install, or"
    echo "   Run ./setup_ubuntu_ci.sh for system install"
    exit 1
fi

# CRITICAL: Clean environment to avoid cross-compilation conflicts
# Remove any ARM cross-compiler paths from the beginning of PATH
export PATH=$(echo "$PATH" | sed 's|/usr/arm-linux-gnueabihf/bin:||g')

# Ensure system binaries come first
export PATH="/usr/bin:/bin:$PATH"

# CRITICAL: Unset global CC variables that might interfere with build scripts
unset CC CXX AR LD

# Set host compiler for build scripts explicitly
export CC_x86_64_unknown_linux_gnu=gcc
export CXX_x86_64_unknown_linux_gnu=g++
export AR_x86_64_unknown_linux_gnu=ar

# Set ARM cross-compilation variables for target compilation only
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER=arm-linux-gnueabihf-gcc
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_CC=arm-linux-gnueabihf-gcc
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_CXX=arm-linux-gnueabihf-g++
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_AR=arm-linux-gnueabihf-ar

# Verify compiler availability
if ! command -v gcc &> /dev/null; then
    echo "❌ Host compiler 'gcc' not found"
    exit 1
fi

if ! command -v arm-linux-gnueabihf-gcc &> /dev/null; then
    echo "❌ ARM cross-compiler 'arm-linux-gnueabihf-gcc' not found"
    exit 1
fi

echo "✅ Cross-compilation environment configured"
echo "   Host compiler (build scripts): $(which gcc)"
echo "   ARM compiler (targets): $(which arm-linux-gnueabihf-gcc)"

# Build web frontend first
echo "📦 Building web frontend..."
cd bin/web

# Clean install to avoid audit warnings during build
echo "  📦 Installing dependencies..."
npm ci --silent --audit=false 2>/dev/null || npm install --silent --audit=false

echo "  🔨 Building web assets..."
npm run build --silent

cd ../..
echo "✅ Web frontend built successfully\n"

# Build core library
echo "🔧 Building core library..."
cargo build --release --target armv7-unknown-linux-musleabihf -p rayhunter
echo "✅ Core library built successfully\n"

# Build telcom-parser
echo "🔧 Building telcom-parser..."
cargo build --release --target armv7-unknown-linux-musleabihf -p telcom-parser
echo "✅ Telcom-parser built successfully\n"

# Build rootshell first (required by installer)
echo "🔧 Building rootshell (firmware profile)..."
cargo build --profile firmware --target armv7-unknown-linux-musleabihf -p rootshell
echo "✅ Rootshell built successfully\n"

# Build daemon
echo "🔧 Building rayhunter-daemon (firmware profile)..."
cargo build --profile firmware --target armv7-unknown-linux-musleabihf --bin rayhunter-daemon
echo "✅ Rayhunter-daemon built successfully\n"

# Build check utility
echo "🔧 Building rayhunter-check (firmware profile)..."
cargo build --profile firmware --target armv7-unknown-linux-musleabihf --bin rayhunter-check
echo "✅ Rayhunter-check built successfully\n"

# Build installer (depends on firmware binaries)
echo "🔧 Building installer..."
cargo build --profile firmware --target armv7-unknown-linux-musleabihf -p installer
echo "✅ Installer built successfully\n"

echo "🎉 All components built successfully!"
echo "====================================="
echo ""
echo "📁 ARM binaries location: target/armv7-unknown-linux-musleabihf/firmware/"
echo "📁 Web files location: bin/web/build/"
echo ""
echo "🚀 To deploy to device, run: ./deploy.sh"
BUILDSCRIPT

chmod +x build_all.sh
echo "✅ Cross-compilation fix applied to build_all.sh"
EOF

chmod +x fix_cross_compilation.sh
./fix_cross_compilation.sh
```

## 📋 **What You Get**

### **Build Environment**
- **Ubuntu 22.04** container with persistent home directory
- **rayhunter user** with password `thehunted` and sudo access
- **All toolchains** installed locally in user space
- **Persistent storage** for source code and build artifacts
- **Full USB device access** for direct deployment
- **GPS integration** with REST API endpoints

### **Build Process**
- **ARM cross-compilation** for target devices
- **Web interface** built with SvelteKit
- **Direct deployment** via adb over USB
- **Clean, repeatable** builds
- **GPS correlation** features included

### **Target Architecture**
- **armv7-unknown-linux-musleabihf** (ARM hard float)
- **Optimized firmware profile** for embedded devices
- **Web interface** accessible at device IP port 8080
- **GPS API** accessible at device IP port 8080

## 🔧 **Configuration Options**

### **Environment Variables**
```bash
# Build configuration
export BUILD_PROFILE=firmware    # or 'release'
export CLEAN_BUILD=true          # Clean before build

# Source configuration  
export REPO_URL=https://github.com/your-fork/rayhunter-enhanced.git
export BRANCH=develop            # or any branch/tag

# GPS configuration
export GPS_API_ENABLED=true      # Enable GPS API endpoints
export GPS_CORRELATION=true      # Enable GPS correlation with captures
```

### **Device Deployment**
```bash
# After deployment, access device
adb shell
su
cd /data/rayhunter
./rayhunter

# Web interface available at:
# http://device-ip:8080

# GPS API available at:
# http://device-ip:8080/api/v1/gps/
```

## 🐛 **Troubleshooting**

### **Cross-Compilation Errors**
**Issue**: ARM linker errors like:
```
/usr/arm-linux-gnueabihf/bin/ld: unrecognised emulation mode: elf_x86_64
```

**Solution**: Apply the cross-compilation fix above, then:
```bash
# Clean and rebuild
cd ~/rayhunter-enhanced
./clean.sh
./build_all.sh
```

**Root Cause**: ARM cross-compiler was being used for build scripts that need to compile for host architecture.

### **Container Issues**
```bash
# Check container status
./docker-build.sh status

# Restart container
./docker-build.sh down
./docker-build.sh up

# Rebuild from scratch
./docker-build.sh rebuild
```

### **Build Issues**
```bash
# Inside container - reload environment
source ~/.rayhunter_build_env

# Clean and rebuild
CLEAN_BUILD=true ./build_and_deploy.sh

# Check dependencies
./setup_ubuntu_ci.sh
```

### **ADB Connection Issues**
```bash
# Check connected devices
adb devices

# Restart adb server
adb kill-server
adb start-server

# Enable USB debugging on device
# Authorize computer connection
```

### **Docker USB Access Issues**
```bash
# Restart container with enhanced USB access
./restart_container_with_usb.sh

# Check USB device permissions
lsusb
# Should show your device

# Verify adb connection from container
adb devices
# Should show device as "device"
```

### **GPS API Issues**
```bash
# Check API endpoint
curl "http://192.168.1.1:8080/api/v1/gps/37.7749,-122.4194"

# Check device logs for GPS correlation errors
adb shell su -c "tail -f /data/rayhunter/rayhunter.log"
```

## 📁 **Project Structure**

```
/home/rayhunter/                   # User home (persistent)
├── setup_ubuntu_ci.sh             # Step 1: Setup script
├── fetch_source.sh                # Step 2: Source fetcher
├── build_and_deploy.sh            # Step 3: Build & deploy
├── .rayhunter_build_env            # Build environment config
└── rayhunter-enhanced/             # Source code (downloaded)
    ├── build_deps/                 # Local dependencies (if using setup_local_deps.sh)
    ├── target/                     # Build artifacts
    ├── bin/                        # Main binaries
    ├── lib/                        # Libraries
    └── tmp-deploy/gps/             # GPS data (during deployment)
```

## 🎯 **Benefits of This Approach**

✅ **Simple**: 3 clear steps, easy to understand  
✅ **Modular**: Each script has a single responsibility  
✅ **Repeatable**: Clean builds every time  
✅ **Persistent**: Build environment and source code persist  
✅ **Flexible**: Easy to modify or extend  
✅ **Self-contained**: Everything in Docker container  
✅ **Fully Automated**: No manual environment loading required  
✅ **Error-proof**: Eliminates "cargo: command not found" issues  
✅ **Cross-compilation fixed**: Handles ARM/host compiler separation properly
✅ **USB device access**: Full access to connected devices
✅ **GPS integration**: Comprehensive GPS API and correlation features

## 🔄 **Development Workflow**

1. **Setup Once**: Run `./setup_ubuntu_ci.sh` (installs toolchains)
2. **Update Source**: Run `./fetch_source.sh` (gets latest code)
3. **Build & Test**: Run `./build_and_deploy.sh` (builds and deploys)
4. **Iterate**: Repeat steps 2-3 as needed

The persistent Docker environment means you only need to set up the toolchains once, then you can quickly fetch updates and rebuild as needed!

## 📱 **GPS Integration Workflow**

1. **Deploy**: Build and deploy with GPS API endpoints
2. **Submit Coordinates**: Use mobile app or curl to submit GPS coordinates
3. **Capture Data**: Record cellular captures with GPS correlation
4. **Export**: Download GPS data in CSV, JSON, or GPX format
5. **Analyze**: Use GPS data for location-based analysis

---

**🎉 Ready to build rayhunter-enhanced with the simplest possible workflow and comprehensive GPS integration!** 