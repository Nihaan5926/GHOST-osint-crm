#!/bin/bash

# Fix translucent/glass styling for better readability

# Replace glass-card with solid backgrounds
find frontend/src/components -name "*.js" -type f -exec sed -i.bak \
  -e 's/glass-card backdrop-blur-xl border border-white\/30 shadow-glass-xl rounded-glass-xl/bg-white dark:bg-gray-800 rounded-lg shadow-2xl border border-gray-200 dark:border-gray-700/g' \
  -e 's/glass-card/bg-white dark:bg-gray-800/g' \
  -e 's/glass-heavy/bg-gray-100 dark:bg-gray-700/g' \
  -e 's/border-white\/20/border-gray-200 dark:border-gray-700/g' \
  -e 's/border-white\/30/border-gray-300 dark:border-gray-600/g' \
  -e 's/text-accent-primary/text-blue-600 dark:text-blue-400/g' \
  -e 's/shadow-glow-sm/shadow-md/g' \
  {} \;

# Fix backdrop blur in modals - keep the overlay blur but make content solid
find frontend/src/components -name "*.js" -type f -exec sed -i.bak2 \
  -e 's/bg-black\/50 backdrop-blur-sm/bg-black\/70/g' \
  -e 's/bg-black\/50/bg-black\/70/g' \
  {} \;

# Ensure headings have proper contrast
find frontend/src/components -name "*.js" -type f -exec sed -i.bak3 \
  -e 's/text-gray-100 dark:text-gray-100/text-gray-900 dark:text-gray-100/g' \
  -e 's/text-white dark:text-white/text-gray-900 dark:text-white/g' \
  {} \;

# Clean up backup files
find frontend/src/components -name "*.bak*" -delete

echo "Readability fixes applied!"
