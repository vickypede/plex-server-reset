#!/bin/bash
# Plex Media Server Preferences.xml Fix Script for Linux/NAS
# This script removes authentication entries to regain access to Plex Server Settings
# Based on: https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/

echo "Plex Media Server Preferences.xml Fix Script"
echo "============================================"
echo ""

# Path to Preferences.xml (update this if your path is different)
PREF_FILE="/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml"

# Check if file exists
if [ ! -f "$PREF_FILE" ]; then
    echo "ERROR: Preferences.xml not found at: $PREF_FILE"
    echo ""
    echo "Please update the PREF_FILE variable in this script with the correct path."
    exit 1
fi

echo "Found Preferences.xml at: $PREF_FILE"
echo ""

# Create backup
BACKUP_FILE="${PREF_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
echo "Creating backup to: $BACKUP_FILE"
cp "$PREF_FILE" "$BACKUP_FILE"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create backup. Aborting."
    exit 1
fi

echo "Backup created successfully."
echo ""

# Check if Plex Media Server is running
if pgrep -f "Plex Media Server" > /dev/null; then
    echo "WARNING: Plex Media Server appears to be running!"
    echo "You should stop Plex Media Server before making changes."
    echo ""
    read -p "Do you want to continue anyway? (yes/no): " continue_anyway
    if [ "$continue_anyway" != "yes" ]; then
        echo "Operation cancelled."
        exit 0
    fi
fi

echo "Removing authentication entries from Preferences.xml..."
echo ""

# Remove the entries using sed
# Remove PlexOnlineHome
sed -i 's/ PlexOnlineHome="[^"]*"//g' "$PREF_FILE"

# Remove PlexOnlineMail
sed -i 's/ PlexOnlineMail="[^"]*"//g' "$PREF_FILE"

# Remove PlexOnlineToken
sed -i 's/ PlexOnlineToken="[^"]*"//g' "$PREF_FILE"

# Remove PlexOnlineUsername
sed -i 's/ PlexOnlineUsername="[^"]*"//g' "$PREF_FILE"

echo "Entries removed successfully!"
echo ""
echo "Next steps:"
echo "1. Start your Plex Media Server (if it was stopped)"
echo "2. Sign in to/claim your Plex Media Server with your Plex account"
echo "3. Your libraries and settings should remain intact"
echo ""
echo "Backup saved at: $BACKUP_FILE"
echo ""

