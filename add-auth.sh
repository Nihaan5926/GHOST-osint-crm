#!/bin/bash

# Script to add authentication middleware to unprotected endpoints

FILE="backend/server.js"

# Backup original file
cp "$FILE" "${FILE}.backup"

# Add requireAuth to travel-history endpoints
sed -i.tmp "s/^app\.put('\/api\/travel-history\/:id', async/app.put('\/api\/travel-history\/:id', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.delete('\/api\/travel-history\/:id', async/app.delete('\/api\/travel-history\/:id', requireAuth, async/" "$FILE"

# Add requireAuth to tools endpoints
sed -i.tmp "s/^app\.get('\/api\/tools', async/app.get('\/api\/tools', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.post('\/api\/tools', async/app.post('\/api\/tools', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.put('\/api\/tools\/:id', async/app.put('\/api\/tools\/:id', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.delete('\/api\/tools\/:id', async/app.delete('\/api\/tools\/:id', requireAuth, async/" "$FILE"

# Add requireAuth to todos endpoints
sed -i.tmp "s/^app\.get('\/api\/todos', async/app.get('\/api\/todos', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.post('\/api\/todos', async/app.post('\/api\/todos', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.put('\/api\/todos\/:id', async/app.put('\/api\/todos\/:id', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.delete('\/api\/todos\/:id', async/app.delete('\/api\/todos\/:id', requireAuth, async/" "$FILE"

# Add requireAdmin to settings endpoints (system-wide settings should be admin-only)
sed -i.tmp "s/^app\.get('\/api\/settings\/custom-fields', async/app.get('\/api\/settings\/custom-fields', requireAdmin, async/" "$FILE"
sed -i.tmp "s/^app\.post('\/api\/settings\/custom-fields', async/app.post('\/api\/settings\/custom-fields', requireAdmin, async/" "$FILE"
sed -i.tmp "s/^app\.put('\/api\/settings\/custom-fields\/:id', async/app.put('\/api\/settings\/custom-fields\/:id', requireAdmin, async/" "$FILE"
sed -i.tmp "s/^app\.delete('\/api\/settings\/custom-fields\/:id', async/app.delete('\/api\/settings\/custom-fields\/:id', requireAdmin, async/" "$FILE"
sed -i.tmp "s/^app\.get('\/api\/settings\/model-options', async/app.get('\/api\/settings\/model-options', requireAdmin, async/" "$FILE"
sed -i.tmp "s/^app\.post('\/api\/settings\/model-options', async/app.post('\/api\/settings\/model-options', requireAdmin, async/" "$FILE"
sed -i.tmp "s/^app\.put('\/api\/settings\/model-options\/:id', async/app.put('\/api\/settings\/model-options\/:id', requireAdmin, async/" "$FILE"
sed -i.tmp "s/^app\.delete('\/api\/settings\/model-options\/:id', async/app.delete('\/api\/settings\/model-options\/:id', requireAdmin, async/" "$FILE"

# Add requireAdmin to export/import (very sensitive operations)
sed -i.tmp "s/^app\.get('\/api\/export', async/app.get('\/api\/export', requireAdmin, async/" "$FILE"
sed -i.tmp "s/^app\.post('\/api\/import', async/app.post('\/api\/import', requireAdmin, async/" "$FILE"

# Add requireAuth to businesses endpoints
sed -i.tmp "s/^app\.get('\/api\/businesses', async/app.get('\/api\/businesses', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.post('\/api\/businesses', async/app.post('\/api\/businesses', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.put('\/api\/businesses\/:id', async/app.put('\/api\/businesses\/:id', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.delete('\/api\/businesses\/:id', async/app.delete('\/api\/businesses\/:id', requireAuth, async/" "$FILE"

# Add requireAuth to wireless-networks endpoints
sed -i.tmp "s/^app\.get('\/api\/wireless-networks', async/app.get('\/api\/wireless-networks', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.get('\/api\/wireless-networks\/:id', async/app.get('\/api\/wireless-networks\/:id', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.post('\/api\/wireless-networks', async/app.post('\/api\/wireless-networks', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.put('\/api\/wireless-networks\/:id', async/app.put('\/api\/wireless-networks\/:id', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.delete('\/api\/wireless-networks\/:id', async/app.delete('\/api\/wireless-networks\/:id', requireAuth, async/" "$FILE"

# Bulk delete should be admin
sed -i.tmp "s/^app\.post('\/api\/wireless-networks\/bulk-delete', async/app.post('\/api\/wireless-networks\/bulk-delete', requireAdmin, async/" "$FILE"

# Import KML needs special handling due to multer middleware
sed -i.tmp "s/^app\.post('\/api\/wireless-networks\/import-kml', multer/app.post('\/api\/wireless-networks\/import-kml', requireAuth, multer/" "$FILE"

sed -i.tmp "s/^app\.get('\/api\/wireless-networks\/stats', async/app.get('\/api\/wireless-networks\/stats', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.get('\/api\/wireless-networks\/nearby', async/app.get('\/api\/wireless-networks\/nearby', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.post('\/api\/wireless-networks\/:id\/associate', async/app.post('\/api\/wireless-networks\/:id\/associate', requireAuth, async/" "$FILE"
sed -i.tmp "s/^app\.delete('\/api\/wireless-networks\/:id\/associate', async/app.delete('\/api\/wireless-networks\/:id\/associate', requireAuth, async/" "$FILE"

# Clean up temporary files
rm -f "${FILE}.tmp"

echo "✓ Authentication middleware added to all endpoints"
echo "✓ Backup saved as ${FILE}.backup"
