# LAMP Stack Installation Script

# Overview

This Bash script automates the installation and configuration of a LAMP (Linux, Apache, MySQL, PHP) stack on a CentOS-based system. It installs Apache, MySQL (MariaDB), and PHP, secures the database, and sets up test scripts #to verify the installation.

# Features

- Updates the system
- Installs and configures Apache
- Installs and secures MySQL (MariaDB)
- Installs PHP and restarts Apache to apply changes
- Creates a test PHP info page (`info.php`)
- Sets up a test database (`testdb`) with a user (`testuser`)
- Creates a PHP script (`dbtest.php`) to verify database connectivity

# Usage

Cloning the Repository
Before running the script, clone the repository:

```
  git clone https://github.com/DanielAmanyi/lamp-script-ec2
  cd lamp-script-ec2
```

# Running the Script

# 1. Copy the script to your server and give it execution permission:

```
 chmod +x script.sh
```

# 3. Run the script with sudo privileges:

```
sudo ./script.sh
```

# Testing the Setup

# - Verify PHP installation: Open a web browser and navigate to:

```
http://your_server_ip/info.php
```

# - Verify database connection: Open a web browser and navigate to:

```
http://your_server_ip/dbtest.php
```

# If successful, you should see "Connected successfully".

# Requirements

- CentOS-based system with `yum` package manager
- Root or sudo privileges

# Notes

- The script uses `mysql_secure_installation` for MySQL security; you must follow the on-screen instructions.
- Default database credentials:
  - Database: `testdb`
  - User: `testuser`
  - Password: `password`
    You should change these for security purposes.

# Disclaimer

This script is provided "as is" without any guarantees. Use it at your own risk, and modify it as needed for your specific setup.
