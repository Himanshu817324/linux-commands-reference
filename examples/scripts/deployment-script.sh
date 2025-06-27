#!/bin/bash
# Application Deployment Script
# Usage: ./deployment-script.sh [environment] [version]

ENVIRONMENT=${1:-staging}
VERSION=${2:-latest}
APP_NAME="myapp"
APP_USER="appuser"
APP_DIR="/opt/$APP_NAME"
SERVICE_NAME="$APP_NAME"
LOG_FILE="/var/log/deployment.log"

# Environment-specific configurations
case $ENVIRONMENT in
    production)
        GIT_BRANCH="main"
        DB_HOST="prod-db.example.com"
        ;;
    staging)
        GIT_BRANCH="develop"
        DB_HOST="staging-db.example.com"
        ;;
    development)
        GIT_BRANCH="dev"
        DB_HOST="localhost"
        ;;
    *)
        echo "Invalid environment: $ENVIRONMENT"
        exit 1
        ;;
esac

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check command success
check_status() {
    if [ $? -eq 0 ]; then
        log_message "SUCCESS: $1"
    else
        log_message "FAILED: $1"
        exit 1
    fi
}

# Pre-deployment checks
log_message "Starting deployment to $ENVIRONMENT environment"
log_message "Application: $APP_NAME, Version: $VERSION"

# Check if service is running
if systemctl is-active --quiet "$SERVICE_NAME"; then
    SERVICE_WAS_RUNNING=true
    log_message "Service $SERVICE_NAME is currently running"
else
    SERVICE_WAS_RUNNING=false
    log_message "Service $SERVICE_NAME is not running"
fi

# Backup current version
if [ -d "$APP_DIR" ]; then
    BACKUP_DIR="/opt/backups/${APP_NAME}_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$(dirname "$BACKUP_DIR")"
    cp -r "$APP_DIR" "$BACKUP_DIR"
    check_status "Current version backed up to $BACKUP_DIR"
fi

# Stop service if running
if [ "$SERVICE_WAS_RUNNING" = true ]; then
    systemctl stop "$SERVICE_NAME"
    check_status "Service $SERVICE_NAME stopped"
fi

# Navigate to application directory
cd "$APP_DIR" || exit 1

# Pull latest code
git fetch origin
git checkout "$GIT_BRANCH"
git pull origin "$GIT_BRANCH"
check_status "Code updated from $GIT_BRANCH branch"

# Install/update dependencies
if [ -f "package.json" ]; then
    npm install --production
    check_status "Node.js dependencies installed"
elif [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    check_status "Python dependencies installed"
elif [ -f "composer.json" ]; then
    composer install --no-dev
    check_status "PHP dependencies installed"
fi

# Build application if needed
if [ -f "package.json" ] && grep -q '"build"' package.json; then
    npm run build
    check_status "Application built"
fi

# Update configuration
if [ -f "config/app.conf.template" ]; then
    sed "s/{{DB_HOST}}/$DB_HOST/g" config/app.conf.template > config/app.conf
    check_status "Configuration updated"
fi

# Set proper permissions
chown -R "$APP_USER:$APP_USER" "$APP_DIR"
check_status "Permissions set"

# Database migrations (if applicable)
if [ -f "migrate.sh" ]; then
    sudo -u "$APP_USER" ./migrate.sh
    check_status "Database migrations applied"
fi

# Start service
systemctl start "$SERVICE_NAME"
check_status "Service $SERVICE_NAME started"

# Wait for service to be ready
sleep 10

# Health check
if curl -f http://localhost:8080/health >/dev/null 2>&1; then
    log_message "Health check passed"
else
    log_message "Health check failed - rolling back"
    
    # Rollback
    systemctl stop "$SERVICE_NAME"
    rm -rf "$APP_DIR"
    mv "$BACKUP_DIR" "$APP_DIR"
    systemctl start "$SERVICE_NAME"
    log_message "Rollback completed"
    exit 1
fi

# Enable service if not already enabled
systemctl enable "$SERVICE_NAME"

log_message "Deployment completed successfully"
log_message "Application $APP_NAME version $VERSION is now running in $ENVIRONMENT"