# Security Audit: Authentication Issues

## Critical Finding: Most Endpoints Are Unprotected

After investigating the authentication requirements, I discovered that **almost all API endpoints in the application are accessible without authentication**. This is a critical security vulnerability.

## Summary

- ✅ **Protected Endpoints:** Only 3 route modules (~15 endpoints)
- ❌ **Unprotected Endpoints:** 40+ endpoints in server.js
- 🔴 **Risk Level:** CRITICAL

## Protected Endpoints (Require Authentication)

These endpoints are properly protected using middleware:

### 1. **Audit Logs** (`/api/audit-logs/*`) - Requires Admin
- `GET /api/audit-logs` - List all audit logs
- `GET /api/audit-logs/entity/:entity_type/:entity_id` - Get logs for specific entity
- `GET /api/audit-logs/stats` - Get audit statistics

### 2. **User Management** (`/api/users/*`) - Requires Admin
- `GET /api/users` - List all users
- `GET /api/users/:id` - Get specific user
- `POST /api/users` - Create new user
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### 3. **Authentication** (`/api/auth/*`) - Mixed
- `POST /api/auth/login` - **Public** (no auth required)
- `GET /api/auth/session` - **Public** (checks session status)
- `POST /api/auth/logout` - **Protected** (requires auth)
- `GET /api/auth/me` - **Protected** (requires auth)
- `PUT /api/auth/me` - **Protected** (requires auth)

## Unprotected Endpoints (No Authentication Required)

### People Management
- ✅ `GET /api/people` - List all people
- ✅ `POST /api/people` - Create person
- ✅ `PUT /api/people/:id` - Update person
- ✅ `DELETE /api/people/:id` - Delete person
- ✅ `GET /api/people/:id/travel-history` - Get travel history
- ✅ `POST /api/people/:id/travel-history` - Add travel history
- ✅ `GET /api/people/:id/travel-analysis` - Get travel analysis

### Case Management
- ✅ `GET /api/cases` - List all cases
- ✅ `POST /api/cases` - Create case
- ✅ `PUT /api/cases/:id` - Update case
- ✅ `DELETE /api/cases/:id` - Delete case

### Business Management
- ✅ `GET /api/businesses` - List all businesses
- ✅ `POST /api/businesses` - Create business
- ✅ `PUT /api/businesses/:id` - Update business
- ✅ `DELETE /api/businesses/:id` - Delete business

### Tools Management
- ✅ `GET /api/tools` - List all tools
- ✅ `POST /api/tools` - Create tool
- ✅ `PUT /api/tools/:id` - Update tool
- ✅ `DELETE /api/tools/:id` - Delete tool

### Todo Management
- ✅ `GET /api/todos` - List all todos
- ✅ `POST /api/todos` - Create todo
- ✅ `PUT /api/todos/:id` - Update todo
- ✅ `DELETE /api/todos/:id` - Delete todo

### Wireless Networks
- ✅ `GET /api/wireless-networks` - List wireless networks
- ✅ `POST /api/wireless-networks` - Create network
- ✅ `PUT /api/wireless-networks/:id` - Update network
- ✅ `DELETE /api/wireless-networks/:id` - Delete network
- ✅ `POST /api/wireless-networks/bulk-delete` - Bulk delete networks
- ✅ `POST /api/wireless-networks/import-kml` - Import KML file
- ✅ `GET /api/wireless-networks/stats` - Get statistics

### Travel History
- ✅ `DELETE /api/travel-history/:id` - Delete travel record

### Settings & Configuration
- ✅ `GET /api/settings/custom-fields` - Get custom fields
- ✅ `POST /api/settings/custom-fields` - Create custom field
- ✅ `PUT /api/settings/custom-fields/:id` - Update custom field
- ✅ `DELETE /api/settings/custom-fields/:id` - Delete custom field
- ✅ `GET /api/settings/model-options` - Get model options
- ✅ `POST /api/settings/model-options` - Create model option
- ✅ `PUT /api/settings/model-options/:id` - Update model option
- ✅ `DELETE /api/settings/model-options/:id` - Delete model option

### Data Import/Export
- ✅ `GET /api/export` - **Export all data** (sensitive!)
- ✅ `POST /api/import` - **Import data** (dangerous!)

### Entity Network
- ✅ `GET /api/entity-network` - Get network data
- ✅ `POST /api/entity-relationships` - Create relationship
- ✅ `PUT /api/entity-relationships/:id` - Update relationship
- ✅ `DELETE /api/entity-relationships/:id` - Delete relationship

### Search & Other
- ✅ `GET /api/search` - Universal search
- ✅ `POST /api/upload/logo` - Upload application logo
- ✅ `GET /api/health` - Health check (OK to be public)
- ✅ Docker control endpoints (if enabled)

## Security Implications

### 1. Data Exposure
Anyone can access all investigation data without authentication:
```bash
# Anyone can download all your data
curl http://localhost:3001/api/export > stolen-data.json

# Anyone can view all people under investigation
curl http://localhost:3001/api/people

# Anyone can view all cases
curl http://localhost:3001/api/cases
```

### 2. Data Manipulation
Anyone can modify or delete data:
```bash
# Anyone can delete a person
curl -X DELETE http://localhost:3001/api/people/1

# Anyone can modify investigation data
curl -X PUT http://localhost:3001/api/cases/1 \
  -H "Content-Type: application/json" \
  -d '{"status":"Closed"}'

# Anyone can import malicious data
curl -X POST http://localhost:3001/api/import \
  -H "Content-Type: application/json" \
  -d @malicious-data.json
```

### 3. Network Exposure
If your Docker containers expose ports beyond localhost (0.0.0.0 binding), this data is accessible from:
- Your local network
- The internet (if port-forwarded)
- Other containers in the same Docker network

## Verification

I tested these endpoints without authentication and they all work:
```bash
# Works without login
curl -s http://localhost:3001/api/people | jq 'length'
# Output: 6

# Works without login
curl -s http://localhost:3001/api/export | jq '.version'
# Output: "1.2"

# Works without login
curl -s http://localhost:3001/api/businesses | jq 'length'
# Output: 2
```

## Why This Happened

The authentication middleware exists (`backend/middleware/auth.js`) and is correctly used in:
- `routes/auth.js`
- `routes/users.js`
- `routes/auditLogs.js`

However, **the main server.js file defines 40+ endpoints that don't use any authentication middleware**.

## Current vs Intended Behavior

**Current behavior:**
- Only audit logs and user management require authentication
- Everything else is wide open

**Likely intended behavior:**
- All endpoints should require authentication
- Some endpoints should require admin role
- Only /health and /auth/login should be public

## Recommendations

### Priority 1: Immediate Protection (Quick Fix)

Add authentication middleware to all sensitive endpoints in `server.js`:

```javascript
const { requireAuth, requireAdmin } = require('./middleware/auth');

// Protect all endpoints
app.use('/api/people', requireAuth);
app.use('/api/cases', requireAuth);
app.use('/api/businesses', requireAuth);
app.use('/api/tools', requireAuth);
app.use('/api/todos', requireAuth);
app.use('/api/wireless-networks', requireAuth);
app.use('/api/settings', requireAuth);
app.use('/api/export', requireAuth);
app.use('/api/import', requireAuth);
app.use('/api/entity-network', requireAuth);
app.use('/api/entity-relationships', requireAuth);
app.use('/api/search', requireAuth);

// Keep these public
// /api/health - OK to be public
// /api/auth/login - needs to be public
// /api/auth/session - OK to check session
```

### Priority 2: Role-Based Access (Better Security)

Some operations should require admin role:
- Data export/import: `requireAdmin`
- User management: Already protected with `requireAdmin` ✓
- Settings/configuration: Should use `requireAdmin`
- Bulk delete operations: Should use `requireAdmin`

### Priority 3: Refactor (Long-term)

Move all endpoints to route modules with proper middleware:
- Create `routes/people.js` with auth middleware
- Create `routes/businesses.js` with auth middleware
- Create `routes/tools.js` with auth middleware
- etc.

## Testing the Fix

After applying authentication:

```bash
# Should fail without authentication
curl http://localhost:3001/api/people
# Expected: {"error":"Authentication required"}

# Should work with authentication
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"ghost","password":"admin123"}' \
  -c cookies.txt

curl -b cookies.txt http://localhost:3001/api/people
# Expected: [array of people]
```

## Current Workarounds

Until this is fixed:

1. **Never expose the backend port (3001) beyond localhost**
   - Don't bind to 0.0.0.0 in production
   - Use firewall rules to block external access
   - Only access via frontend (port 8080)

2. **Use network isolation**
   - Keep in private Docker network
   - Use VPN for remote access
   - Don't port-forward 3001 through router

3. **Use frontend exclusively**
   - The frontend enforces login
   - Users can't access API directly through UI
   - But API is still vulnerable to direct HTTP requests

## Compliance & Legal

For OSINT/investigation tools handling sensitive data:
- GDPR requires access controls on personal data
- Law enforcement data must be protected
- Audit trails must track who accessed what (currently not possible without auth)
- This vulnerability could invalidate evidence chain of custody

## Status

- 🔴 **Current Status:** VULNERABLE
- ⚠️ **Impact:** HIGH - Complete data exposure and manipulation
- 🎯 **Recommendation:** Apply authentication middleware immediately
- ⏱️ **Effort to Fix:** Low (30 minutes to add middleware)
- 📋 **Testing Effort:** Medium (need to verify all endpoints still work)

---

**Note:** This is a design/implementation issue, not a bug. The authentication system works correctly where it's applied - it just isn't applied to most endpoints. This suggests the application may have started as a local-only tool and authentication was added later but not comprehensively.
