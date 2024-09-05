#!/bin/bash

# Set permissions for the files
chmod -R 755 /var/www/html

# Restart web server (assuming Apache; adjust if using Nginx or another server)
systemctl restart apache2

