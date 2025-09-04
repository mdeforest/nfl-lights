# How to Enable the Webhook Fallback

If the native NFL integration doesn't work for you, you can use the webhook trigger as a fallback option. This allows you to trigger the Eagles celebration from external services like IFTTT, Zapier, or custom scripts.

## Enabling the Webhook Automation

1. **Edit the package file**: Open `packages/eagles_lights.yaml`

2. **Uncomment the webhook automation**: Find the section titled "WEBHOOK TRIGGER AUTOMATION (OPTION B - FALLBACK)" and uncomment the entire automation block by removing the `#` characters.

3. **Restart Home Assistant**: The webhook will be available at `/api/webhook/eagles_scored`

## Testing the Webhook

### Basic Test
```bash
curl -X POST \
  http://YOUR_HA_IP:8123/api/webhook/eagles_scored \
  -H "Content-Type: application/json" \
  -d '{}'
```

### Test with Custom Duration
```bash
curl -X POST \
  http://YOUR_HA_IP:8123/api/webhook/eagles_scored \
  -H "Content-Type: application/json" \
  -d '{"duration": 20}'
```

### GET Request (simpler for some services)
```bash
curl http://YOUR_HA_IP:8123/api/webhook/eagles_scored
```

## External Service Integration

### IFTTT Setup
1. Create a new applet at [ifttt.com](https://ifttt.com)
2. **If This**: Choose "ESPN" or "RSS Feed" with Eagles scoring feed
3. **Then That**: Choose "Webhooks" -> "Make a web request"
4. **URL**: `http://YOUR_HA_IP:8123/api/webhook/eagles_scored`
5. **Method**: POST
6. **Content Type**: application/json
7. **Body**: `{}`

### Zapier Setup
1. Create a new Zap at [zapier.com](https://zapier.com)
2. **Trigger**: ESPN or sports data source with Eagles filter
3. **Action**: "Webhooks by Zapier" -> "POST"
4. **URL**: `http://YOUR_HA_IP:8123/api/webhook/eagles_scored`
5. **Payload Type**: JSON
6. **Data**: `{}`

### Custom Script Example (Python)
```python
import requests
import json

def trigger_eagles_celebration(duration=15):
    url = "http://YOUR_HA_IP:8123/api/webhook/eagles_scored"
    data = {"duration": duration}
    
    try:
        response = requests.post(url, json=data)
        if response.status_code == 200:
            print("Eagles celebration triggered!")
        else:
            print(f"Error: {response.status_code}")
    except Exception as e:
        print(f"Failed to trigger: {e}")

# Usage
trigger_eagles_celebration(20)  # 20-second celebration
```

## Security Considerations

### Local Network Only
The webhook is accessible without authentication, so it's recommended to only allow access from your local network:

1. **Router Settings**: Block external access to port 8123
2. **Home Assistant**: Use the `http` integration with `use_x_forwarded_for` and `trusted_proxies` if behind a reverse proxy

### Using HTTPS
For external access, always use HTTPS:
1. Set up a reverse proxy (nginx, Cloudflare Tunnel, etc.)
2. Use the secure webhook URL: `https://YOUR_DOMAIN/api/webhook/eagles_scored`

## Advanced Webhook Payloads

The webhook accepts JSON data with these optional parameters:

```json
{
  "duration": 15,        // Celebration duration in seconds
  "force": true,         // Bypass cooldown period
  "test": true,          // Enable dry-run mode for this trigger
  "brightness": 80,      // Override brightness level
  "quiet": false         // Force quiet mode (solid color only)
}
```

### Example with all parameters:
```bash
curl -X POST \
  http://YOUR_HA_IP:8123/api/webhook/eagles_scored \
  -H "Content-Type: application/json" \
  -d '{
    "duration": 25,
    "force": false,
    "test": false,
    "brightness": 90,
    "quiet": false
  }'
```

## Troubleshooting

### Webhook not responding:
1. Check Home Assistant logs for errors
2. Verify the webhook automation is enabled and uncommented
3. Test with a simple GET request first
4. Check firewall settings

### Webhook responding but lights not changing:
1. Enable dry-run mode to test logic
2. Check if `input_boolean.do_not_disturb` is enabled
3. Verify cooldown period hasn't been exceeded
4. Check Home Assistant logbook for celebration messages

### External service not triggering:
1. Test the webhook manually first
2. Check service-specific logs (IFTTT activity, Zapier history)
3. Verify the external service can reach your Home Assistant instance
4. Consider using a webhook testing service like ngrok for debugging

## Integration Examples

### Node-RED Flow
For Node-RED users, create a flow that:
1. Monitors ESPN API for Eagles scores
2. Sends HTTP POST to the webhook when score increases
3. Includes error handling and logging

### Home Assistant Template Sensor
You can also create a template sensor that monitors external APIs:

```yaml
sensor:
  - platform: rest
    name: "Eagles Score Monitor"
    url: "http://site.api.espn.com/apis/site/v2/sports/football/nfl/teams/phi"
    json_attributes:
      - team
    value_template: "{{ value_json.team.record.items[0].stats[1].value }}"
    scan_interval: 30
```

Then trigger the webhook based on state changes to this sensor.

Go Eagles! 🦅