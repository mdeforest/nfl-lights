# Example Customization for Eagles Lights Package
# 
# Copy sections from this file to customize your installation
# This shows common customizations you might want to make

###############################################################################
# CUSTOM LIGHT ENTITIES
# Replace the default light entities with your own
###############################################################################

# If you have different light entities, update these sections in eagles_lights.yaml:

# 1. Update the scene creation snapshot (around line 110):
# snapshot_entities:
#   - light.your_living_room_light
#   - light.your_kitchen_light
#   - light.your_bedroom_light
#   - light.your_govee_backlight

# 2. Update the repeat loop for flashing (around line 125):
# for_each:
#   - light.your_living_room_light
#   - light.your_kitchen_light
#   - light.your_bedroom_light
#   - light.your_govee_backlight

# 3. Update the final celebration lights (around line 175):
# entity_id:
#   - light.your_living_room_light
#   - light.your_kitchen_light
#   - light.your_bedroom_light
#   - light.your_govee_backlight

###############################################################################
# CUSTOM TEAM COLORS
# Change colors for a different team
###############################################################################

# For different team colors, update these variables (around line 115):
# variables:
#   celebration_brightness: >
#     {{ day_brightness if now().hour >= 8 and now().hour < 22 else night_brightness }}
#   team_color_rgb: [255, 0, 0]     # Example: Red team
#   team_color_hs: [0, 100]         # Example: Red in HSV

# Common NFL team colors:
# Eagles: [0, 76, 84] / [186, 100]
# Cowboys: [0, 34, 68] / [213, 100] 
# Giants: [1, 35, 82] / [220, 99]
# Redskins: [63, 16, 16] / [0, 75]
# Patriots: [0, 13, 40] / [220, 100]
# Steelers: [255, 182, 18] / [43, 93]

###############################################################################
# CUSTOM ENTITY NAMES
# Change entity names if you want different naming
###############################################################################

# You can rename the input helpers by changing their keys:
input_boolean:
  my_team_do_not_disturb:    # Instead of do_not_disturb
    name: "Eagles Do Not Disturb"
    icon: mdi:bell-off
    initial: false

  my_team_dry_run:           # Instead of eagles_dry_run
    name: "Eagles Test Mode"
    icon: mdi:eye
    initial: false

input_number:
  my_team_cooldown:          # Instead of eagles_cooldown_seconds
    name: "Eagles Cooldown"
    min: 15
    max: 300
    step: 5
    initial: 45

# Remember to update all references to these entities throughout the package!

###############################################################################
# CUSTOM TIMING SETTINGS
# Adjust celebration timing and behavior
###############################################################################

# To change default durations, update these in the script fields:
# duration_seconds:
#   default: 20              # Instead of 15
# day_brightness:
#   default: 90              # Instead of 80
# night_brightness:
#   default: 60              # Instead of 50

# To change quiet hours, update this condition (around line 114):
# celebration_brightness: >
#   {{ day_brightness if now().hour >= 7 and now().hour < 23 else night_brightness }}
# (This example changes quiet hours to 11 PM - 7 AM instead of 10 PM - 8 AM)

###############################################################################
# CUSTOM NFL INTEGRATION ENTITY
# If your NFL integration creates different entity names
###############################################################################

# Update the trigger entity_id in both automations:
# trigger:
#   - platform: state
#     entity_id: sensor.philadelphia_eagles_game    # Your actual entity name
#     attribute: team_score

# Check what attributes your NFL sensor provides and update accordingly:
# - team_score vs score_home/score_away
# - game_status vs state
# - opponent_score vs other team tracking

###############################################################################
# ADDITIONAL LIGHT TYPES
# Handle lights that don't support color
###############################################################################

# For lights that only support brightness (no color), you can add conditional logic:

# Add this check before setting hs_color:
# - choose:
#     - conditions:
#         - condition: template
#           value_template: "{{ 'hs_color' in state_attr(light_entity, 'supported_features') }}"
#       sequence:
#         - service: light.turn_on
#           target:
#             entity_id: "{{ light_entity }}"
#           data:
#             brightness_pct: "{{ enhanced_brightness }}"
#             hs_color: "{{ eagles_green_hs }}"
#             transition: 0.5
#   default:
#     - service: light.turn_on
#       target:
#         entity_id: "{{ light_entity }}"
#       data:
#         brightness_pct: "{{ enhanced_brightness }}"
#         transition: 0.5

###############################################################################
# WEBHOOK CUSTOMIZATION
# Modify webhook behavior and endpoints
###############################################################################

# To use a different webhook endpoint, change:
# webhook_id: my_team_scored              # Instead of eagles_scored

# To add webhook authentication:
# trigger:
#   - platform: webhook
#     webhook_id: eagles_scored
#     allowed_methods:
#       - POST
#     local_only: true                     # Only allow local network

# To handle different webhook payloads:
# action:
#   - service: script.eagles_celebrate_score
#     data:
#       duration_seconds: "{{ trigger.json.duration | default(15) }}"
#       day_brightness: "{{ trigger.json.brightness | default(80) }}"
#       solid_only: "{{ trigger.json.quiet | default(false) }}"

###############################################################################
# MULTIPLE TEAMS SUPPORT
# Track multiple teams in the same installation
###############################################################################

# You can duplicate the entire package and modify for multiple teams:
# 1. Copy eagles_lights.yaml to cowboys_lights.yaml
# 2. Change all entity names (eagles_ prefix to cowboys_)
# 3. Update colors and team references
# 4. Use different NFL integration entities
# 5. Create separate webhook endpoints

# Example for multiple teams:
# input_boolean:
#   eagles_do_not_disturb:
#   cowboys_do_not_disturb:
#   
# script:
#   eagles_celebrate_score:
#   cowboys_celebrate_score:
#
# automation:
#   - id: eagles_score_trigger
#   - id: cowboys_score_trigger

###############################################################################
# ADVANCED EFFECTS
# More complex light patterns and effects
###############################################################################

# For more complex flashing patterns, you can extend the repeat sequence:
# - repeat:
#     count: 5                            # More flashes
#     sequence:
#       - service: light.turn_on
#         target:
#           entity_id: "{{ light_entity }}"
#         data:
#           brightness_pct: "{{ enhanced_brightness }}"
#           hs_color: "{{ eagles_green_hs }}"
#           transition: 0.3
#       - delay:
#           milliseconds: 400
#       - service: light.turn_on
#         target:
#           entity_id: "{{ light_entity }}"
#         data:
#           brightness_pct: 10
#           hs_color: "{{ eagles_green_hs }}"
#           transition: 0.2
#       - delay:
#           milliseconds: 200

# For color cycling effects:
# - repeat:
#     count: 3
#     sequence:
#       - service: light.turn_on
#         data:
#           hs_color: [186, 100]           # Eagles green
#       - delay: { seconds: 1 }
#       - service: light.turn_on
#         data:
#           hs_color: [30, 100]            # Gold/yellow
#       - delay: { seconds: 1 }