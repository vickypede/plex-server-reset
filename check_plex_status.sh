#!/bin/bash
# Check Plex status and Preferences.xml

echo "=== Plex Media Server Status ==="
/usr/syno/bin/synopkg status PlexMediaServer

echo ""
echo "=== Checking Preferences.xml for authentication entries ==="
PREF_FILE="/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml"

if [ -f "$PREF_FILE" ]; then
    echo "File exists and is readable"
    echo ""
    echo "Looking for any PlexOnline entries:"
    grep -i "plexonline" "$PREF_FILE" || echo "No PlexOnline entries found"
    echo ""
    echo "Checking file permissions:"
    ls -la "$PREF_FILE"
    echo ""
    echo "First 20 lines of Preferences.xml:"
    head -20 "$PREF_FILE"
else
    echo "ERROR: Preferences.xml not found at $PREF_FILE"
fi

echo ""
echo "=== Checking if Plex process is running ==="
ps aux | grep -i plex | grep -v grep || echo "No Plex processes found"

