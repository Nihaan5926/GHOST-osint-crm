# Changelog

All notable changes to GHOST OSINT CRM will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2026-01-26

### 🔒 Security Improvements

#### Critical Security Enhancements
- **Environment Variable Validation**: Added production-mode validation that requires `DB_PASSWORD` and `SESSION_SECRET` to be set
- **Weak Password Detection**: Application now exits in production if weak passwords are detected (e.g., 'changeme', 'password', 'admin')
- **Session Secret Enforcement**: Requires minimum 32-character `SESSION_SECRET` in production mode
- **Docker Security**: Backend container now runs as non-root user (nodejs:1001) instead of root
- **Database Port Exposure**: Added security warning for exposed PostgreSQL port in docker-compose.yml
- **Environment Documentation**: Updated `.env.example` with security warnings and generation commands

### 🐛 Bug Fixes

#### Database & Authentication
- **Fixed Issue #2**: Users table now created automatically during database initialization
  - Previously required manual migration file execution
  - Users table creation integrated into `initializeDatabase()` function
  - Added foreign key constraint from `audit_logs` to `users` table
  - **Email field made optional**: Users can now be created without an email address
- **Connection Pool Leaks Fixed**: Added try-finally blocks to ensure database connections are always released
  - Fixed in `backend/middleware/audit.js`
  - Fixed in `backend/server.js` audit logging function

### ⚡ Performance Improvements

#### Database Indexing
- **People Table Indexes**: Added indexes on frequently queried fields
  - `idx_people_first_name`, `idx_people_last_name`, `idx_people_full_name`
  - `idx_people_category`, `idx_people_status`, `idx_people_case_name`, `idx_people_dob`
- **Users Table Indexes**: Added for faster lookups
  - `idx_users_username`, `idx_users_email`, `idx_users_role`
- **Audit Logs Indexes**: Improved audit query performance
  - `idx_audit_logs_entity`, `idx_audit_logs_user_id`
  - `idx_audit_logs_created_at`, `idx_audit_logs_action`

### 🎯 Features

#### User Management
- **Optional Email Field**: Admin users can now be created without providing an email address
  - Database schema updated to make email nullable
  - `createAdminUser.js` script updated to accept optional email
  - Migration file updated for existing databases

#### System Stability
- **Graceful Shutdown**: Added proper shutdown handlers for production environments
  - Handles SIGTERM and SIGINT signals
  - Closes HTTP server gracefully
  - Waits for database pool to close before exit
  - 10-second timeout for forced shutdown
- **Uncaught Exception Handling**: Added handlers for uncaught exceptions and unhandled promise rejections
- **Health Check Endpoint**: Added `/api/health` endpoint for monitoring
  - Returns server status, uptime, and database connectivity
  - Used by Docker healthchecks

#### Docker Improvements
- **Service Health Checks**: All Docker services now have health checks
  - Database: PostgreSQL readiness check
  - Backend: HTTP health endpoint check with 40s startup time
  - Frontend: Nginx availability check
- **Dependency Management**: Services start only when dependencies are healthy
  - Backend waits for healthy database
  - Frontend waits for healthy backend

### 📝 Documentation

#### New Documentation
- **CHANGELOG.md**: This file - comprehensive change tracking
- **Setup Instructions**: Updated README.md with complete setup guide including:
  - User creation command
  - Security best practices
  - Environment variable configuration
  - Troubleshooting section

#### Updated Documentation
- **README.md**: Enhanced with security warnings and setup instructions
- **.env.example**: Added detailed comments for all security-related variables
- **Docker Configuration**: Added inline comments explaining security implications

### 🔧 Technical Changes

#### Configuration
- Production mode now validates critical environment variables on startup
- Development mode shows warnings for default/weak credentials
- Added `FRONTEND_URL` environment variable for CORS configuration

#### Database Schema
- Users table email column changed from `NOT NULL` to nullable
- Added automatic `ALTER TABLE` command to update existing databases
- All new tables created with proper indexes from initialization

### 🚀 Migration Guide

#### For Existing Installations

1. **Pull Latest Changes**
   ```bash
   git pull origin main
   ```

2. **Update Environment Variables**
   ```bash
   # Generate a strong session secret
   openssl rand -base64 32

   # Add to .env file
   SESSION_SECRET=<generated-secret>
   FRONTEND_URL=http://localhost:8080
   ```

3. **Rebuild and Restart Containers**
   ```bash
   docker-compose down -v  # Warning: This deletes all data!
   docker-compose up --build
   ```

4. **Create Admin User**
   ```bash
   docker exec -it osint-crm-backend node scripts/createAdminUser.js
   ```

#### Breaking Changes
- **Production Mode**: Application will not start without proper `DB_PASSWORD` and `SESSION_SECRET`
- **Email Field**: Existing code expecting email to always be present should handle NULL values

### 📊 Statistics

- **Files Changed**: 7
- **Security Issues Fixed**: 9 high-priority
- **Performance Improvements**: 13 database indexes added
- **Lines Added**: ~200
- **Lines Removed**: ~50

### 🙏 Acknowledgments

Issues and improvements identified through:
- Community bug reports (Issue #2)
- Implemented two PRs - thx @erLCoder
- Done a small security audit
- Performance profiling
- Docker best practices review

---

## [2.0.0] - 2025-10-XX

Initial release with core OSINT investigation features.

### Features
- People management and tracking
- Entity network visualization
- Global intelligence mapping
- Wireless network intelligence (WiGLE integration)
- Case management
- Business intelligence tracking
- Modern UI with dark mode
- Docker deployment

---

**Legend:**
- 🔒 Security
- 🐛 Bug Fix
- ⚡ Performance
- 🎯 Feature
- 📝 Documentation
- 🔧 Technical
- 🚀 Migration
