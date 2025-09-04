#!/bin/bash

# Eagles Lights Installation Script for Home Assistant
# This script helps you install the Eagles lights automation package

set -e

echo "🦅 Eagles Lights Home Assistant Installation Script"
echo "================================================="
echo ""

# Check if we're in a Home Assistant environment
if [ ! -d "/config" ]; then
    echo "⚠️  This script is designed to run on Home Assistant OS"
    echo "   Please copy the files manually if using a different setup"
    echo ""
    echo "   Required files:"
    echo "   - packages/eagles_lights.yaml -> /config/packages/"
    echo "   - Enable packages in configuration.yaml"
    exit 1
fi

# Create packages directory if it doesn't exist
echo "📁 Creating packages directory..."
mkdir -p /config/packages

# Check if packages are enabled in configuration.yaml
if ! grep -q "packages:" /config/configuration.yaml; then
    echo "⚙️  Packages not found in configuration.yaml"
    echo "   Adding packages configuration..."
    
    echo "" >> /config/configuration.yaml
    echo "# Enable packages directory" >> /config/configuration.yaml
    echo "homeassistant:" >> /config/configuration.yaml
    echo "  packages: !include_dir_named packages" >> /config/configuration.yaml
    
    echo "✅ Added packages configuration to configuration.yaml"
else
    echo "✅ Packages already configured in configuration.yaml"
fi

# Copy the eagles_lights.yaml file
if [ -f "./packages/eagles_lights.yaml" ]; then
    echo "📋 Copying Eagles lights package..."
    cp ./packages/eagles_lights.yaml /config/packages/
    echo "✅ Eagles lights package installed"
else
    echo "❌ eagles_lights.yaml not found in ./packages/"
    echo "   Please ensure you're running this script from the repository root"
    exit 1
fi

# Check for NFL integration
echo ""
echo "🏈 Checking for NFL integration..."
if [ -d "/config/custom_components/nfl" ]; then
    echo "✅ NFL integration found"
    echo "   Make sure it's configured for Philadelphia Eagles"
else
    echo "⚠️  NFL integration not found"
    echo "   Install from HACS: https://github.com/zacs/ha-nfl"
    echo "   Or enable the webhook fallback in the package file"
fi

# Validate YAML syntax
echo ""
echo "🔍 Validating YAML syntax..."
python3 -c "
import yaml
try:
    with open('/config/packages/eagles_lights.yaml', 'r') as f:
        yaml.safe_load(f)
    print('✅ YAML syntax is valid')
except Exception as e:
    print(f'❌ YAML syntax error: {e}')
    exit(1)
"

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart Home Assistant"
echo "2. Configure your light entities in the package file if different from:"
echo "   - light.living_room_main"
echo "   - light.kitchen_pendants"
echo "   - light.tv_backlight_govee"
echo "3. Install the NFL integration from HACS (Option A)"
echo "   OR enable the webhook automation (Option B)"
echo "4. Test with the 'Test Eagles Celebration' button"
echo ""
echo "📚 Documentation:"
echo "   - README.md - Complete setup guide"
echo "   - WEBHOOK_SETUP.md - Webhook configuration"
echo ""
echo "Go Eagles! 🦅💚"