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

# Install MySQL (MariaDB)
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

# Generate and encrypt deployment report
progress "Generating deployment report..."

CSV_FILE="deployment_report.csv"
ENCRYPTED_FILE="deployment_report.enc"

# Collect required details
SERVER_IP=$(hostname -I | awk '{print $1}')
PHP_VERSION=$(php -v | head -n 1)
APACHE_STATUS=$(sudo systemctl is-active httpd)
MYSQL_STATUS=$(sudo systemctl is-active mariadb)

# Write details to CSV
echo "Item,Details" > $CSV_FILE
echo "Server IP,$SERVER_IP" >> $CSV_FILE
echo "Database Name,testdb" >> $CSV_FILE
echo "Database User,testuser" >> $CSV_FILE
echo "Database Password,password" >> $CSV_FILE
echo "Test PHP Page,http://$SERVER_IP/info.php" >> $CSV_FILE
echo "Test DB Connection,http://$SERVER_IP/dbtest.php" >> $CSV_FILE
echo "PHP Version,$PHP_VERSION" >> $CSV_FILE
echo "Apache Status,$APACHE_STATUS" >> $CSV_FILE
echo "MySQL Status,$MYSQL_STATUS" >> $CSV_FILE
echo "Apache Log Path,/var/log/httpd/error_log" >> $CSV_FILE
echo "MySQL Log Path,journalctl -u mariadb" >> $CSV_FILE

# Encrypt the CSV with OpenSSL using AES-256
progress "Encrypting deployment report..."
openssl enc -aes-256-cbc -salt -pbkdf2 -in $CSV_FILE -out $ENCRYPTED_FILE -k admin

# Cleanup the plaintext CSV
rm -f $CSV_FILE

progress "LAMP stack installation complete!"
progress "Encrypted deployment report saved as '$ENCRYPTED_FILE'."
progress "To decrypt: openssl enc -aes-256-cbc -d -pbkdf2 -in $ENCRYPTED_FILE -out decrypted_report.csv -k admin"
