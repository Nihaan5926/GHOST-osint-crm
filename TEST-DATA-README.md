# Test Data Import Guide

## Overview

This file contains comprehensive test data for the GHOST OSINT CRM system. The data simulates realistic intelligence gathering scenarios across multiple investigation cases.

## File Location

`test-data.json` - Located in the project root directory

## What's Included

### 3 Investigation Cases
1. **Operation Phantom Network** - Cybercrime syndicate investigation
2. **Corporate Espionage - TechCorp** - Trade secret theft investigation
3. **Missing Person - Sarah Chen** - Missing person case with digital footprint tracking

### 6 People Records
- **Marcus Rivera** - Primary suspect, cybercrime (Operation Phantom Network)
- **Elena Volkov** - Suspect, cryptography expert (Operation Phantom Network)
- **David Chen** - Person of Interest, former TechCorp employee (Corporate Espionage)
- **Natasha Volkov** - Associate, financial analyst (Operation Phantom Network)
- **Sarah Chen** - Victim, missing person (Missing Person case)
- **James Morrison** - Witness, last person to see Sarah Chen

Each person includes:
- Complete biographical data
- OSINT data (phone numbers, emails, social media)
- Relationship connections
- Multiple locations (residence, work)
- Custom fields (threat levels, languages, clearances)
- Case associations

### 2 Businesses
- **CyberShield Solutions LLC** - Suspected front company
- **TechCorp Industries** - Victim company in espionage case

### 8 OSINT Tools
Pre-configured tool inventory including:
- Maltego (Data Mining)
- theHarvester (Reconnaissance)
- Shodan (Network Intelligence)
- SpiderFoot (Automation)
- Recon-ng (Framework)
- Social-Analyzer (Social Media)
- WiGLE WiFi (Wireless Intelligence)
- OSINT Framework (Reference)

### 8 Investigation Tasks
Tasks across all cases showing different statuses (Pending, In Progress, Completed)

### 5 Travel History Records
International and domestic travel tracking for key suspects

### Custom Fields & Model Options
- Threat level classification system
- Security clearance levels
- Language tracking
- Additional person categories and statuses

## How to Import

### Method 1: Using the API (Recommended)

**Prerequisites:**
- GHOST application running (Docker or manual)
- API accessible at `http://localhost:3001`
- User authenticated in the system

**Import via cURL:**
```bash
# Step 1: Login first (required after security fix)
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"ghost","password":"admin123"}' \
  -c cookies.txt

# Step 2: Import data
curl -X POST http://localhost:3001/api/import \
  -H "Content-Type: application/json" \
  -b cookies.txt \
  -d @test-data.json
```

**Import via Postman/Insomnia:**
1. Create a new POST request
2. URL: `http://localhost:3001/api/import`
3. Headers: `Content-Type: application/json`
4. Body: Select "raw" and "JSON", paste contents of `test-data.json`
5. Send request

**Using JavaScript/Fetch:**
```javascript
const testData = require('./test-data.json');

fetch('http://localhost:3001/api/import', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  credentials: 'include', // Important for session cookies
  body: JSON.stringify(testData)
})
.then(response => response.json())
.then(data => console.log('Import successful:', data))
.catch(error => console.error('Import failed:', error));
```

### Method 2: Using the Frontend

If the frontend has an import feature:
1. Log into GHOST frontend
2. Navigate to Settings or Data Management section
3. Look for "Import Data" or "Bulk Import" option
4. Upload `test-data.json` file
5. Confirm import

### Method 3: Direct Database Import (Advanced)

**Warning:** This bypasses application logic and should only be used for development.

```bash
# Access the database container
docker exec -it osint-crm-db psql -U postgres -d osint_crm_db

# Then manually insert records using SQL
# (Not recommended - use API instead)
```

## Import Behavior

The import endpoint uses `ON CONFLICT` clauses for some tables:
- **Cases**: Updates existing cases with matching `case_name`
- **Custom Fields**: Updates existing fields with matching `field_name`
- **Model Options**: Updates existing options with matching `model_type` and `option_value`
- **People, Businesses, Tools, Todos**: Creates new records each time

## After Import

### Verify the Import

1. **Check Cases:** Navigate to Cases section - should see 3 cases
2. **Check People:** Should see 6 people with detailed profiles
3. **Check Entity Network:** View the relationship diagram showing connections
4. **Check Map:** See locations plotted on the global map
5. **Check Businesses:** 2 businesses should be listed
6. **Check Tools:** 8 OSINT tools in the arsenal
7. **Check Tasks:** 8 todos with various statuses

### Explore the Data

**Entity Network Visualization:**
- Marcus Rivera → Elena Volkov (Business Associates)
- Marcus Rivera → David Chen (Known Associates)
- Elena Volkov → Natasha Volkov (Sisters)
- Sarah Chen → James Morrison (Romantic relationship)

**Map View:**
- **La Jolla, CA:** Marcus Rivera, Elena Volkov, CyberShield Solutions
- **San Jose, CA:** David Chen, TechCorp Industries
- **San Diego, CA:** Natasha Volkov
- **San Francisco, CA:** Sarah Chen (residence and work), James Morrison

**Travel History:**
- Track Marcus Rivera's trip to Moscow
- Elena Volkov's Berlin visit for hacker conference
- David Chen's suspicious Austin trip after resignation
- Sarah Chen's last trip to LA before disappearance

## Test Scenarios

### Scenario 1: Link Analysis
Trace the connections between CyberShield Solutions employees and the corporate espionage case:
1. View Marcus Rivera's profile
2. Check his connections to David Chen
3. Analyze meeting patterns and financial transactions
4. Map the network in Entity Network view

### Scenario 2: Geographic Intelligence
Use the map to identify patterns:
1. Filter map by "Operation Phantom Network" case
2. Notice clustering of suspects in La Jolla area
3. Check travel history for international connections
4. Identify key meeting locations

### Scenario 3: Missing Person Investigation
Follow the Sarah Chen case:
1. Review last known locations
2. Check social media timestamps
3. Interview witness (James Morrison)
4. Analyze digital footprint

### Scenario 4: Threat Assessment
Use custom fields to prioritize investigations:
1. Filter people by threat_level = "high"
2. Review OSINT data for each high-priority target
3. Check surveillance tasks
4. Coordinate with FBI on international aspects

## Cleanup

To remove test data and start fresh:

### Option 1: Manual Deletion (Selective)
Use the GHOST interface to delete individual records

### Option 2: Database Reset (Complete)
```bash
# WARNING: This deletes ALL data
docker-compose down -v
docker-compose up --build

# Or if running manually:
psql -U postgres -d osint_crm_db -c "TRUNCATE people, cases, businesses, tools, todos, travel_history, custom_person_fields, model_options RESTART IDENTITY CASCADE;"
```

## Customization

Feel free to modify `test-data.json` to:
- Add more people, businesses, or cases
- Create additional relationship types
- Add more OSINT data sources
- Expand travel history
- Create custom field types
- Add your own investigation scenarios

## Data Format Notes

### JSON Structure
```json
{
  "version": "2.1.0",
  "data": {
    "cases": [...],
    "customFields": [...],
    "modelOptions": [...],
    "businesses": [...],
    "people": [...],
    "tools": [...],
    "todos": [...],
    "travelHistory": [...]
  }
}
```

### Important Fields

**JSONB Fields** (must be valid JSON):
- `osint_data` - Array of objects
- `attachments` - Array of objects
- `connections` - Array of objects
- `locations` - Array of objects
- `custom_fields` - Object (key-value pairs)
- `employees` (in businesses) - Array of objects

**Date Formats:**
- Use ISO 8601: `YYYY-MM-DD` for dates
- Use ISO 8601: `YYYY-MM-DDTHH:MM:SSZ` for timestamps

**Foreign Key Relationships:**
- Person IDs are automatically remapped during import
- Business IDs are automatically remapped during import
- Case names must match exactly for associations

## Troubleshooting

### Import Failed - Invalid Format
- Ensure JSON is valid (use a JSON validator)
- Check that all required fields are present
- Verify JSONB fields contain valid JSON

### Duplicate Data
- Cases, custom fields, and model options use `ON CONFLICT` to update
- People and other records will create duplicates on re-import
- Delete existing records before re-importing if needed

### Foreign Key Errors
- Ensure case names in people records match actual case names
- The import handles person_id remapping automatically

### Missing Relationships
- Connections between people are established via the `connections` array
- Ensure both people are included in the import for relationships to work

## Support

For issues or questions:
1. Check the main README.md
2. Review server logs: `docker-compose logs backend`
3. Open an issue on GitHub
4. Check database state: `docker exec osint-crm-db psql -U postgres -d osint_crm_db`

## License

This test data is provided under the same license as the GHOST project (CC BY-NC-SA 4.0).

**Note:** All names, businesses, and scenarios in this test data are fictional and for demonstration purposes only. Any resemblance to real persons or entities is coincidental.
