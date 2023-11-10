#!/bin/bash


# Parse command-line arguments or set default values
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -v|--version)
        VERSION="$2"
        shift
        shift
        ;;
        -a|--arch)
        ARCH="$2"
        shift
        shift
        ;;
        *)
        # Unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

PROJECT_NAME="tedge-mqtt-proxy"
# Set binary and system-d paths
BINARY_PATH="/etc/tedge/plugins"
SYSTEMD_PATH="/lib/systemd/system"
SYSTEMD_SERVICE="tedge-mqtt-proxy.service"

# Create the necessary directories in the package staging area
PACKAGE_DIR="./$PROJECT_NAME-$VERSION"
mkdir -p "$PACKAGE_DIR$BINARY_PATH"
mkdir -p "$PACKAGE_DIR$SYSTEMD_PATH"
mkdir -p "$PACKAGE_DIR/DEBIAN"

# Copy the built binary and systemd file to the staging area
cp "$PROJECT_NAME" "$PACKAGE_DIR$BINARY_PATH/"
cp "$SYSTEMD_SERVICE" "$PACKAGE_DIR$SYSTEMD_PATH/"

# Create the Debian control file
touch "$PACKAGE_DIR/DEBIAN/control"
echo "Package: $PROJECT_NAME" > "$PACKAGE_DIR/DEBIAN/control"
echo "Version: $VERSION" >> "$PACKAGE_DIR/DEBIAN/control"
echo "Architecture: $ARCH" >> "$PACKAGE_DIR/DEBIAN/control"
echo "Maintainer: felix.schaede@softwareag.coma" >> "$PACKAGE_DIR/DEBIAN/control"
echo "Description: Simple thin-edge mqtt/http proxy" >> "$PACKAGE_DIR/DEBIAN/control"

# Create the postinst script to the DEBIAN directory
touch "$PACKAGE_DIR/DEBIAN/postinst"
echo "chmod +x $SYSTEMD_PATH/$SYSTEMD_SERVICE" >> "$PACKAGE_DIR/DEBIAN/postinst"
echo "systemctl enable $SYSTEMD_PATH/$SYSTEMD_SERVICE" >> "$PACKAGE_DIR/DEBIAN/postinst"
echo "exit 0" >> "$PACKAGE_DIR/DEBIAN/postinst"

# Make the postinst script executable
chmod +x "$PACKAGE_DIR/DEBIAN/postinst"

# Build the Debian package
dpkg-deb --build "$PACKAGE_DIR"

# Clean up the staging area
rm -r "$PACKAGE_DIR"

echo "Package built and installed successfully!"