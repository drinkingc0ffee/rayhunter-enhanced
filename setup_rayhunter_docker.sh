#!/bin/bash

# Rayhunter Enhanced Docker Build Environment Setup
# This script creates a persistent Docker container for building rayhunter-enhanced

set -e

echo "🐳 Setting up Rayhunter Enhanced Docker Build Environment"
echo "=========================================================="

# Configuration
CONTAINER_NAME="rayhunter-build-docker"
IMAGE_NAME="ubuntu:22.04"
SOURCE_DIR="/Users/beisenmann/rayhunter-enhanced-f1"
CONTAINER_WORK_DIR="/home/rayhunter"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    print_error "Source directory $SOURCE_DIR does not exist"
    exit 1
fi

# Stop and remove existing container if it exists
if docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    print_status "Removing existing container: $CONTAINER_NAME"
    docker stop "$CONTAINER_NAME" > /dev/null 2>&1 || true
    docker rm "$CONTAINER_NAME" > /dev/null 2>&1 || true
fi

# Create the container
print_status "Creating persistent container: $CONTAINER_NAME"
docker run -d \
    --name "$CONTAINER_NAME" \
    --hostname rayhunter-build \
    -p 8081:8080 \
    -p 3001:3000 \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /dev:/dev \
    --device-cgroup-rule='c 189:* rmw' \
    --cap-add=SYS_RAWIO \
    --privileged \
    "$IMAGE_NAME" \
    tail -f /dev/null

# Wait for container to be ready
print_status "Waiting for container to be ready..."
sleep 3

# Install essential packages in the container
print_status "Installing essential packages in container..."
docker exec "$CONTAINER_NAME" bash -c "
    apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    pkg-config \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    vim \
    nano \
    htop \
    tree \
    unzip \
    zip \
    usbutils \
    android-tools-adb \
    android-tools-fastboot \
    udev \
    && rm -rf /var/lib/apt/lists/*
"

# Create rayhunter user
print_status "Setting up rayhunter user..."
docker exec "$CONTAINER_NAME" bash -c "
    useradd -m -s /bin/bash rayhunter || true
    usermod -aG sudo rayhunter
    echo 'rayhunter ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/rayhunter
    mkdir -p $CONTAINER_WORK_DIR
    chown rayhunter:rayhunter $CONTAINER_WORK_DIR
"

# Copy shell scripts and markdown files
print_status "Copying shell scripts and documentation..."
docker exec "$CONTAINER_NAME" bash -c "
    mkdir -p $CONTAINER_WORK_DIR
    chown rayhunter:rayhunter $CONTAINER_WORK_DIR
"

# Copy all .sh files
docker cp "$SOURCE_DIR"/*.sh "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"

# Copy all .md files
docker cp "$SOURCE_DIR"/*.md "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"

# Copy Cargo.toml files
docker cp "$SOURCE_DIR"/Cargo.toml "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"
docker cp "$SOURCE_DIR"/Cargo.lock "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"

# Copy .cargo directory
docker cp "$SOURCE_DIR"/.cargo "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"

# Copy source directories
docker cp "$SOURCE_DIR"/bin "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"
docker cp "$SOURCE_DIR"/lib "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"
docker cp "$SOURCE_DIR"/installer "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"
docker cp "$SOURCE_DIR"/rootshell "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"
docker cp "$SOURCE_DIR"/telcom-parser "$CONTAINER_NAME:$CONTAINER_WORK_DIR/"

# Set proper permissions
docker exec "$CONTAINER_NAME" bash -c "
    chown -R rayhunter:rayhunter $CONTAINER_WORK_DIR
    chmod +x $CONTAINER_WORK_DIR/*.sh
"

# Create a welcome message
docker exec "$CONTAINER_NAME" bash -c "
    cat > $CONTAINER_WORK_DIR/welcome.txt << 'EOF'
🔧 Rayhunter Enhanced Build Environment
=======================================

📋 Simple 3-Step Build Process:
1. ./setup_ubuntu_ci.sh     - Install toolchains & dependencies
2. ./fetch_source.sh        - Download latest source code (if needed)
3. ./build_and_deploy.sh    - Build and install via adb

🎯 Quick start: Run all steps with:
   ./setup_ubuntu_ci.sh && ./fetch_source.sh && ./build_and_deploy.sh

📁 Project files are in: $CONTAINER_WORK_DIR
🐳 Container name: $CONTAINER_NAME

🚀 To access the container:
   docker exec -it $CONTAINER_NAME bash

📱 USB Device Access:
   - USB devices are accessible via /dev/bus/usb
   - ADB and fastboot tools are pre-installed
   - Use 'lsusb' to list USB devices
   - Use 'adb devices' to list connected Android devices
   - Container has privileged access for USB operations

🔧 USB Troubleshooting:
   - If devices aren't detected: restart container
   - Check host USB permissions: ls -la /dev/bus/usb
   - Verify ADB server: adb start-server
   - Test USB access: lsusb

EOF
"

print_success "Docker container setup completed!"
echo ""
echo "📋 Container Information:"
echo "   Name: $CONTAINER_NAME"
echo "   Working Directory: $CONTAINER_WORK_DIR"
echo "   User: rayhunter"
echo ""
echo "🚀 Next Steps:"
echo "   1. Access the container: docker exec -it $CONTAINER_NAME bash"
echo "   2. Navigate to: cd $CONTAINER_WORK_DIR"
echo "   3. Run: ./setup_ubuntu_ci.sh"
echo "   4. Run: ./build_and_deploy.sh"
echo ""
echo "📖 Available build scripts:"
docker exec "$CONTAINER_NAME" bash -c "ls -la $CONTAINER_WORK_DIR/*.sh | head -10"
echo ""
print_success "Setup complete! You can now build rayhunter-enhanced in the container." 