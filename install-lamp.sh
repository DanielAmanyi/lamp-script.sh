#!/bin/bash

# Function to display progress in green
function progress {
    echo -e "\e[32m$1\e[0m"
}

# Update the system
progress "Updating the system..."
sudo yum update -y

# Install Apache
progress "Installing Apache..."
sudo yum install -y httpd
progress "Starting Apache..."
sudo systemctl start httpd
progress "Enabling Apache to start on boot..."
sudo systemctl enable httpd

# Install MySQL
progress "Installing MySQL..."
sudo yum install -y mariadb-server mariadb
progress "Starting MySQL..."
sudo systemctl start mariadb
progress "Enabling MySQL to start on boot..."
sudo systemctl enable mariadb

# Secure MySQL installation
progress "Securing MySQL installation..."
sudo mysql_secure_installation

# Install PHP
progress "Installing PHP..."
sudo yum install -y php php-mysqlnd
progress "Restarting Apache to load PHP..."
sudo systemctl restart httpd

# Create a PHP info file
progress "Creating PHP info file..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Create a test database and user
progress "Creating test database and user..."
sudo mysql -u root -p -e "CREATE DATABASE testdb;"
sudo mysql -u root -p -e "CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON testdb.* TO 'testuser'@'localhost';"
sudo mysql -u root -p -e "FLUSH PRIVILEGES;"

# Create a PHP script to test database connection
progress "Creating PHP script to test database connection..."
echo "<?php
\$servername = 'localhost';
\$username = 'testuser';
\$password = 'password';
\$dbname = 'testdb';

// Create connection
\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

// Check connection
if (\$conn->connect_error) {
    die('Connection failed: ' . \$conn->connect_error);
}
echo 'Connected successfully';
?>" | sudo tee /var/www/html/dbtest.php

progress "LAMP stack installation complete! You can test the setup by accessing http://your_server_ip/info.php and http://your_server_ip/dbtest.php"