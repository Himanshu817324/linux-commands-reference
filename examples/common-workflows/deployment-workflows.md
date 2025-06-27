### deployment-workflows.md
  
# Deployment Workflows

## Web Application Deployment
 
# Pull latest code
git pull origin main

# Install dependencies
npm install

# Build application
npm run build

# Restart services
sudo systemctl restart nginx
sudo systemctl restart app-service
Docker Container Deployment
bash# Build and deploy container
docker build -t myapp:latest .
docker stop myapp-container 2>/dev/null || true
docker rm myapp-container 2>/dev/null || true
docker run -d --name myapp-container -p 80:8080 myapp:latest
Blue-Green Deployment
bash# Switch traffic between blue and green environments
if [ "$CURRENT" = "blue" ]; then
    NEW_ENV="green"
else
    NEW_ENV="blue"
fi

# Update load balancer configuration
sed -i "s/server_$CURRENT/server_$NEW_ENV/" /etc/nginx/sites-available/app
nginx -s reload
