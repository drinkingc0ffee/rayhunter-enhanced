#!/bin/bash

echo "=== Testing Build for Restructured Project ==="
echo ""

echo "🔍 Checking project structure..."
echo "Current directory: $(pwd)"
echo ""

echo "📁 Checking key directories exist:"
for dir in check daemon lib installer telcom-parser rootshell tools; do
    if [ -d "$dir" ]; then
        echo "  ✅ $dir/"
    else
        echo "  ❌ $dir/ (missing)"
    fi
done
echo ""

echo "📄 Checking key files exist:"
for file in Cargo.toml check/Cargo.toml daemon/Cargo.toml lib/Cargo.toml; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
    fi
done
echo ""

echo "🐳 Setting up Docker build environment..."
echo "Running: ./setup_rayhunter_docker.sh"
echo ""

echo "🏗️  Testing build in Docker container..."
echo "This will:"
echo "1. Set up Ubuntu 22.04 Docker container"
echo "2. Install Rust and dependencies"
echo "3. Build the restructured project"
echo "4. Verify all components compile"
echo ""

echo "Ready to proceed? (y/N): "
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Starting build test..."
    ./setup_rayhunter_docker.sh
else
    echo "Build test cancelled."
fi 