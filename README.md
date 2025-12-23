# jenkins-health-alert

# 📧 Simple Ubuntu Gmail Setup (msmtp + mutt)

Automate email sending from your Ubuntu server using Gmail. This script sets up **msmtp** (a lightweight SMTP client) and **mutt** (a terminal email client) in seconds.

Great for sending server alerts, logs, or backups via email!

## 🚀 Prerequisites

Before running the script, you need a **Gmail App Password**. You cannot use your regular Gmail login password because Google blocks "less secure apps."

1. Go to your [Google Account Security Settings](https://myaccount.google.com/security).
2. Enable **2-Step Verification** (if not already on).
3. Search for **"App Passwords"**.
4. Create a new app name (e.g., "Ubuntu Server") and copy the **16-character code** it gives you.

## 🛠️ Installation

### 1. Download the Script

Copy the `mail-creation.sh` file to your server.

### 2. Make it Executable

Give the script permission to run:

```bash
chmod +x mail-creation.sh

```

### 3. Run the Setup

Run the script to install the packages and generate the configuration files:

```bash
./mail-creation.sh

```

### 4. Add Your Password (Crucial Step!)

The script configures msmtp to look for a secure file containing your password. You need to create this manually for security reasons.

Run this command (replace the text with your 16-digit Google App Password):

```bash
echo "your 16 digit app password" > ~/.gmail_app_password
chmod 600 ~/.gmail_app_password

```

## ✅ How to Test

Once installed, send a test email to yourself to make sure it works.

**Using msmtp (Simple):**

```bash
echo "Hello! This is a test from my server." | msmtp -a default your-email@gmail.com

```

**Using Mutt (With Subject Line):**

```bash
echo "This is the body of the email" | mutt -s "Test Email Subject" your-email@gmail.com

```

**Sending an Attachment:**

```bash
echo "Here is the log file you requested." | mutt -s "Server Logs" -a /path/to/file.log -- your-email@gmail.com

```

## 📂 Configuration Details

* **Config File:** `~/.msmtprc`
* **Password File:** `~/.gmail_app_password`
* **Logs:** Logging is disabled in this configuration to avoid permission errors.

## 🤝 Contributing

Feel free to fork this and add features like log rotation or multi-account support!****
