# 🏗️ Build Guide - Rayhunter Enhanced

This guide covers how to build and deploy the rayhunter-enhanced project with comprehensive cross-compilation support and multiple setup options.

## 🚀 Quick Start

### Option 1: Docker Environment (Recommended for New Users)
```bash
# Start Docker environment
./docker.sh up
./docker.sh shell

# Inside container - simple 3-step process
./setup_ubuntu_ci.sh
./fetch_source.sh  
./build_and_deploy.sh
```

### Option 2: Local Dependencies (No Root Required)
```bash
# Install all dependencies locally (no root access needed)
./setup_local_deps.sh

# Build everything
./build_all.sh

# Deploy to device
./deploy.sh
```

### Option 3: System Dependencies (Ubuntu)
```bash
# Install system-wide dependencies (requires sudo)
./setup_ubuntu_ci.sh

# Build everything
./build_all.sh

# Deploy to device
./deploy.sh
```

### Option 4: Manual Build
```bash
# Clean previous builds
./clean.sh

# Build everything (automatically detects environment)
./build_all.sh

# Deploy to device
./deploy.sh
```

**Note:** Build scripts automatically detect and use local dependencies first, then fall back to system dependencies.

## 🐳 Docker Environment

The Docker environment provides a complete, isolated build environment with all dependencies pre-configured:

### Getting Started with Docker
```bash
# Build and start container
./docker.sh up

# Open shell in container  
./docker.sh shell

# Inside container - run the automated 3-step build
./setup_ubuntu_ci.sh && ./fetch_source.sh && ./build_and_deploy.sh
```

### Docker Commands
```bash
./docker.sh build     # Build the Docker image
./docker.sh up        # Start container
./docker.sh down      # Stop container
./docker.sh shell     # Open shell in running container
./docker.sh status    # Show container status
./docker.sh clean     # Remove container and image
./docker.sh rebuild   # Clean and rebuild everything
```

### Docker Benefits
- ✅ **Isolated environment** - No system modifications
- ✅ **All dependencies included** - Ubuntu 22.04 with full toolchain
- ✅ **Persistent storage** - Work survives container restarts
- ✅ **Cross-compilation ready** - ARM toolchain pre-configured
- ✅ **adb support** - Direct device deployment via USB

See `DOCKER_BUILD_GUIDE.md` for complete Docker documentation.

## 📋 Prerequisites

### System Requirements
- **Rust** (latest stable version)
- **Node.js** and **npm**
- **adb** (Android Debug Bridge) for device deployment
- **ARM cross-compilation toolchain**

### Setup Options

#### Option 1: Docker Environment (Simplest)
**Fully isolated** - uses Docker container with everything pre-installed:

```bash
# Start Docker environment
./docker.sh up
./docker.sh shell

# Inside container, everything is ready to use
```

#### Option 2: Local Dependencies (Recommended for Native)
**No root access required** - installs everything in `./build_deps`:

```bash
# Install all dependencies locally
./setup_local_deps.sh

# Everything is installed in ./build_deps directory
# No system modifications required
```

#### Option 3: Ubuntu System Setup
For Ubuntu users, use the automated setup scripts:

```bash
# Automated setup (for CI/CD and simple installs)
./setup_ubuntu_ci.sh

# Interactive setup (recommended for development)
./setup_ubuntu_build_env.sh

# Both scripts require a regular user with sudo privileges
```

See `UBUNTU_SETUP.md` for detailed Ubuntu setup instructions.

### Manual ARM Target Installation
```bash
rustup target add armv7-unknown-linux-musleabihf

# Set ARM cross-compilation environment variables (target-specific)
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER=arm-linux-gnueabihf-gcc
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_CC=arm-linux-gnueabihf-gcc
```

**Note**: The setup scripts automatically configure these environment variables with proper host/target separation to avoid cross-compilation conflicts.

## 🔧 Cross-Compilation Environment

### Recent Improvements
The build system has been enhanced with comprehensive cross-compilation fixes:

- ✅ **Proper host/target separation** - Build scripts compile for host (x86_64), target binaries for ARM
- ✅ **PATH management** - Ensures correct compiler resolution
- ✅ **Environment isolation** - Prevents ARM compiler from interfering with build scripts  
- ✅ **Automatic verification** - Tests cross-compilation setup before building

### Test Cross-Compilation Setup
```bash
# Test that cross-compilation environment is working correctly
./test_cross_compilation.sh

# This verifies:
# - Build scripts compile for host architecture
# - Target binaries compile for ARM
# - No compiler conflicts
```

### What the Fixes Solve
Previous issues like these are now resolved:
```
/usr/arm-linux-gnueabihf/bin/ld: unrecognised emulation mode: elf_x86_64
Supported emulations: armelf_linux_eabi armelfb_linux_eabi
```

## 🏠 Local Dependencies

The `setup_local_deps.sh` script installs all build dependencies locally without requiring root access:

### What Gets Installed Locally:
- **Rust** (latest stable) → `./build_deps/rust/`
- **Node.js** (LTS) → `./build_deps/node/`
- **ARM GCC Toolchain** → `./build_deps/arm-toolchain/`
- **Android Debug Bridge** → `./build_deps/adb/`

### Usage:
```bash
# Install local dependencies (only needs to be done once)
./setup_local_deps.sh

# Build scripts automatically detect and use local dependencies
./build_all.sh
```

### Environment Management:
```bash
# Manual environment setup (if needed)
source ./build_deps/setup-env.sh

# Or use the convenience script
source ./use-local-deps.sh
```

### Benefits:
- ✅ **No root access required**
- ✅ **Isolated environment** - doesn't affect system
- ✅ **Reproducible builds** - exact versions for everyone
- ✅ **Easy cleanup** - just delete `./build_deps` directory
- ✅ **CI/CD friendly** - perfect for automated builds
- ✅ **Cross-compilation ready** - proper ARM toolchain setup

### Disk Usage:
Typical installation size: ~1.5GB total
- Rust: ~400MB
- Node.js: ~50MB
- ARM Toolchain: ~900MB
- ADB: ~10MB

## 🛠️ Build Scripts

All build scripts have been enhanced with cross-compilation fixes and environment management:

### `./build_all.sh` (Main Build Script)
Comprehensive build script that:
- ✅ **Automatic environment detection** - Local deps → System → Manual
- ✅ **Cross-compilation fixes** - Proper host/target separation
- ✅ **Build verification** - Tests setup before building
- ✅ **Builds web frontend** (SvelteKit)
- ✅ **Builds Rust library** 
- ✅ **Builds all ARM firmware binaries**
- ✅ **Handles dependencies** in correct order

### `./make.sh` (Quick Build)
Streamlined build script that:
- ✅ **Fast ARM compilation** for all targets
- ✅ **Web frontend building**
- ✅ **Same cross-compilation fixes** as build_all.sh
- ✅ **Minimal output** for quick iterations

### `./clean.sh` (Cleanup)
Enhanced cleanup script that:
- ✅ **Cross-compilation environment fixes**
- ✅ **Removes all Cargo build artifacts**
- ✅ **Removes web build artifacts** 
- ✅ **Removes node_modules**
- ✅ **Cleans npm cache**
- ✅ **Prepares for fresh build**

### `./deploy.sh` (Deployment)
Deployment script that:
- ✅ **Checks device connection**
- ✅ **Stops existing daemon**
- ✅ **Deploys binaries and web interface**
- ✅ **Reboots device**
- ✅ **Starts daemon service**

### `./test_cross_compilation.sh` (NEW - Verification)
Test script that verifies:
- ✅ **Build environment setup**
- ✅ **Host compiler availability** (gcc)
- ✅ **ARM cross-compiler availability** (arm-linux-gnueabihf-gcc)
- ✅ **Correct compiler resolution** (cc → gcc, not ARM)
- ✅ **Build script compilation** for host architecture
- ✅ **ARM cross-compilation** functionality

## 🔧 Manual Build Process

If you need to build components individually:

### 1. Web Frontend
```bash
cd bin/web
npm ci --silent --audit=false
npm run build --silent
cd ../..
```

### 2. Rust Library
```bash
cargo build --release --target armv7-unknown-linux-musleabihf -p rayhunter
```

### 3. Firmware Binaries
```bash
# Build rootshell first (required by installer)
cargo build --profile firmware --target armv7-unknown-linux-musleabihf -p rootshell

# Build daemon
cargo build --profile firmware --target armv7-unknown-linux-musleabihf --bin rayhunter-daemon

# Build utilities
cargo build --profile firmware --target armv7-unknown-linux-musleabihf --bin rayhunter-check

# Build installer (depends on firmware binaries)
cargo build --profile firmware --target armv7-unknown-linux-musleabihf -p installer
```

## 📁 Build Output Locations

- **ARM Binaries**: `target/armv7-unknown-linux-musleabihf/firmware/`
- **Web Interface**: `bin/web/build/`

## 🎯 Build Profiles

- **release**: Standard release build with debug info
- **firmware**: Optimized for embedded devices (smaller size, no debug info)

## 🐛 Troubleshooting

### Cross-Compilation Issues

**Problem**: ARM linker errors like:
```
/usr/arm-linux-gnueabihf/bin/ld: unrecognised emulation mode: elf_x86_64
```

**Solution**: The build scripts now automatically fix this by:
```bash
# Test your environment
./test_cross_compilation.sh

# If issues persist, run clean build
./clean.sh
./build_all.sh
```

**Root Cause**: ARM cross-compiler was being used for build scripts that need to compile for host architecture.

### Environment Issues

**Problem**: `cargo: command not found` or missing dependencies

**Solution**: 
```bash
# For Docker environment
./docker.sh shell
# Everything is pre-installed

# For local setup
./setup_local_deps.sh    # No root required
# OR
./setup_ubuntu_ci.sh     # System-wide (requires sudo)

# Verify setup
./test_cross_compilation.sh
```

### Build Script Issues

**Problem**: Build fails with dependency or linking errors

**Solution**:
```bash
# Clean everything and rebuild
./clean.sh
./build_all.sh

# Test environment first
./test_cross_compilation.sh

# Check build artifacts
ls -la target/armv7-unknown-linux-musleabihf/firmware/
```

### Web Frontend Issues

**Problem**: npm vulnerabilities or build warnings

**Solutions**:
```bash
# Clean npm cache and rebuild
cd bin/web
rm -rf node_modules package-lock.json
npm cache clean --force
npm ci --audit=false
npm run build
cd ../..
```

### Device Connection Issues

**Problem**: Device not accessible via adb

**Solutions**:
```bash
# Check connected devices
adb devices
# Should show your device as "device"

# Restart adb server
adb kill-server
adb start-server

# Check device permissions
adb shell su -c "ls -la /data/"
```

### ARM Cross-Compilation Environment Issues

**Problem**: Wrong architecture compilation or linker errors

**Solutions**:
```bash
# Verify environment variables are set correctly
./test_cross_compilation.sh

# Check PATH and compiler resolution
which gcc          # Should be host compiler
which arm-linux-gnueabihf-gcc  # Should be ARM compiler

# Manually set if needed (build scripts do this automatically)
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER=arm-linux-gnueabihf-gcc
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_CC=arm-linux-gnueabihf-gcc

# Or re-run setup
source ~/.rayhunter_build_env  # If using Ubuntu setup
# OR
source ./build_deps/setup-env.sh  # If using local deps
```

### Advanced Troubleshooting

#### Clean Everything
```bash
# Remove all build artifacts
./clean.sh

# Remove local dependencies (if using local setup)
rm -rf ./build_deps

# Start fresh
./setup_local_deps.sh  # or ./setup_ubuntu_ci.sh
./build_all.sh
```

#### Verify Cross-Compilation Setup
```bash
# Run comprehensive environment test
./test_cross_compilation.sh

# Check that build scripts use host compiler
./build_all.sh 2>&1 | grep -E "(gcc|arm-linux)"

# Verify ARM binaries are correct architecture
file target/armv7-unknown-linux-musleabihf/firmware/rayhunter-daemon
# Should show: ARM, EABI5 version 1 (SYSV), dynamically linked
```

## 📝 Technical Notes

### Cross-Compilation Architecture
- **Host Architecture**: x86_64 (for build scripts and tools)
- **Target Architecture**: armv7-unknown-linux-musleabihf (for device binaries)
- **Linker Strategy**: Target-specific environment variables only
- **PATH Management**: Host compilers first, then ARM cross-compilers

### Dependencies
- **lib/Cargo.toml**: Updated with correct tokio and chrono features
- **bin/web/package.json**: Updated dependencies for security fixes  
- **Build Order**: Web → Library → Firmware → Installer
- **Profiles**: Use `firmware` profile for device binaries

### Build Environment
- **Environment Detection**: Local deps → System → Manual fallback
- **Cross-Compilation**: Automatic host/target separation
- **Verification**: Pre-build environment testing
- **Error Prevention**: Eliminates common cross-compilation issues

## 🔄 CI/CD

The GitHub Actions workflows are configured correctly and will:
- Build web interface
- Build firmware binaries  
- Run tests
- Create release packages

For local development, use the scripts in this guide.

## 📚 Related Documentation

- **[DOCKER_BUILD_GUIDE.md](DOCKER_BUILD_GUIDE.md)** - Complete Docker environment guide
- **[UBUNTU_SETUP.md](UBUNTU_SETUP.md)** - Ubuntu-specific setup instructions
- **[README_ENHANCED.md](README_ENHANCED.md)** - Project overview and features
- **[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete documentation index 