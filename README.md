# Eagles Lights Home Assistant Automation

This repository contains a complete Home Assistant package for automatically turning your lights Eagles-green when the Philadelphia Eagles score during NFL games.

## Features

- 🦅 **Automatic Score Detection**: Triggers when Eagles score (touchdown, field goal, safety, etc.)
- 💚 **Eagles Green**: Perfect Eagles green color (#004C54)
- 🏠 **Smart Behavior**: Different actions for lights that are on vs off
- 🔇 **Do Not Disturb**: Manual override to disable celebrations
- ⏱️ **Cooldown Period**: Prevents rapid re-triggers (configurable, default 45s)
- 🌙 **Quiet Hours**: Solid colors instead of flashing during late/early hours
- 🧪 **Test Mode**: Dry run mode and manual test button
- 🏆 **Win Celebration**: Extended celebration when Eagles win the game

## Installation

1. **Copy the package file**:
   - Place `packages/eagles_lights.yaml` in your Home Assistant `packages/` directory
   - If you don't have a packages directory, create one and add this to your `configuration.yaml`:
   ```yaml
   homeassistant:
     packages: !include_dir_named packages
   ```

2. **Restart Home Assistant**

3. **Choose your trigger method** (see options below)

## Trigger Options

### Option A: Native NFL Integration (Recommended)

Install the NFL integration from HACS:

1. Install [HACS](https://hacs.xyz/) if not already installed
2. Add the NFL integration: https://github.com/zacs/ha-nfl
3. Configure it for the Philadelphia Eagles
4. Update the entity ID in the automation if needed (default: `sensor.nfl_philadelphia_eagles`)

**Entity IDs to check after installation:**
- `sensor.nfl_philadelphia_eagles` (main game sensor)
- Check the `team_score` and `opponent_score` attributes
- Verify `game_status` attribute shows game states

### Option B: Webhook Trigger (Fallback)

If the native integration doesn't work, enable the webhook automation by uncommenting the `eagles_score_webhook_trigger` automation in the package file.

## Webhook Usage Examples

### Basic webhook call:
```bash
curl -X POST \
  http://YOUR_HA_IP:8123/api/webhook/eagles_scored \
  -H "Content-Type: application/json" \
  -d '{}'
```

### Webhook with custom duration:
```bash
curl -X POST \
  http://YOUR_HA_IP:8123/api/webhook/eagles_scored \
  -H "Content-Type: application/json" \
  -d '{"duration": 20}'
```

### IFTTT Integration
1. Create an IFTTT applet with ESPN or other sports trigger
2. Set the action to "Webhooks" -> "Make a web request"
3. URL: `http://YOUR_HA_IP:8123/api/webhook/eagles_scored`
4. Method: POST
5. Content Type: application/json
6. Body: `{}`

### Zapier Integration
1. Create a Zap with ESPN or sports data trigger
2. Add action: "Webhooks by Zapier" -> "POST"
3. URL: `http://YOUR_HA_IP:8123/api/webhook/eagles_scored`
4. Payload Type: JSON
5. Data: `{}`

## Configuration

### Light Entities
Update these in the package file to match your setup:
- `light.living_room_main`
- `light.kitchen_pendants`
- `light.tv_backlight_govee`

### Colors & Timing
- **Eagles Green**: #004C54 (HSV: 186°, 100%, 33%)
- **Duration**: 15 seconds (configurable via `input_number.eagles_celebration_duration`)
- **Cooldown**: 45 seconds (configurable via `input_number.eagles_cooldown_seconds`)
- **Quiet Hours**: 10 PM - 8 AM (solid color instead of flashing)

### Behavior Details

**When lights are OFF:**
- Briefly flash Eagles green 3 times (700ms on, 300ms off)
- Hold solid green for remaining duration
- Return to off state

**When lights are ON:**
- Save current state
- Flash Eagles green at enhanced brightness (+15%, max 100%)
- Hold solid green for remaining duration  
- Restore exact previous state (color, brightness, effects)

## Controls

After installation, you'll have these new entities:

### Input Helpers
- `input_boolean.do_not_disturb` - Disable all celebrations
- `input_boolean.eagles_dry_run` - Test mode (logs only, no light changes)
- `input_number.eagles_cooldown_seconds` - Cooldown between celebrations
- `input_number.eagles_celebration_duration` - How long celebrations last
- `input_button.test_eagles_celebration` - Manual test button

### Scripts
- `script.eagles_celebrate_score` - Main celebration script
- `script.eagles_celebrate_win` - Extended win celebration

### Automations
- "Eagles Score - Native Sensor" - Triggers on score increase
- "Eagles Win Celebration" - Triggers on game final (if Eagles won)
- "Eagles Test Celebration" - Triggered by test button

## Testing

1. **Enable dry run mode**: Turn on `input_boolean.eagles_dry_run`
2. **Press test button**: Use `input_button.test_eagles_celebration`
3. **Check logbook**: Look for celebration messages
4. **Disable dry run**: Turn off dry run mode when ready for real celebrations

## Troubleshooting

### No triggers during games:
1. Check if the NFL integration is working: `sensor.nfl_philadelphia_eagles`
2. Verify the entity has `team_score` and `game_status` attributes
3. Check if `input_boolean.do_not_disturb` is off
4. Verify cooldown period hasn't been exceeded

### Lights don't change:
1. Test with dry run mode enabled first
2. Check if light entities exist and are responsive
3. Verify Govee lights support color changes in HA
4. Check Home Assistant logs for errors

### Webhook not working:
1. Verify Home Assistant is accessible at the webhook URL
2. Check firewall settings
3. Test with a simple GET request first
4. Check Home Assistant logs for webhook errors

## Customization

### Different Team
To adapt for another NFL team:
1. Change the NFL integration configuration
2. Update entity IDs in automations
3. Modify colors in the script variables
4. Update names and IDs throughout the package

### Additional Lights
Add more light entities to these locations in the script:
- Scene creation snapshot
- Light iteration loops
- Final state restoration

### Different Colors
Modify these variables in the script:
- `eagles_green_rgb: [0, 76, 84]`
- `eagles_green_hs: [186, 100]`

## Support

This package is designed for Home Assistant OS on the stable channel with the America/New_York timezone. For issues:

1. Check Home Assistant logs
2. Verify all entities exist and are responsive
3. Test with dry run mode enabled
4. Check the NFL integration documentation if using Option A

Go Eagles! 🦅💚