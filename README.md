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



# 🛡️ Jenkins Auto-Healing Monitor

A robust Bash script designed to monitor the health of your Jenkins service. It automatically detects downtime, sends alerts, and attempts to "self-heal" by restarting the service without human intervention.

## ✨ Features

* **Real-time Monitoring:** Checks `systemctl` status to verify if Jenkins is active.
* **Instant Alerts:** Sends a "CRITICAL ALERT" email immediately upon failure.
* **Auto-Healing:** Automatically attempts to restart the Jenkins service using `sudo`.
* **Recovery Confirmation:** Sends a "RECOVERY ALERT" email once the service is back up.
* **Logging:** Maintains a detailed history of health checks and actions in `$HOME/jenkins-health.log`.

## 📋 Prerequisites

* Ubuntu/Debian Linux Server
* Jenkins installed (via `systemd`)
* `mail` utility installed and configured (e.g., `msmtp`, `postfix`)

---

## 🚀 Installation & Setup

### 1. Download the Script

Create a directory and the script file:

```bash
mkdir -p ~/jenkins-health-alert
nano ~/jenkins-health-alert/jenkins-health-alert.sh

```

*Copy and paste the script code into this file.*

### 2. Make it Executable

Grant execution permissions to the script:

```bash
chmod +x ~/jenkins-health-alert/jenkins-health-alert.sh

```

### 3. Configure Alerts

Open the script and edit the `EMAILS` variable to your preferred email address:

```bash
EMAILS="your-email@example.com"

```

---

## 🔐 Permission Configuration (Crucial)

Since the script runs automatically via Cron, it needs permission to restart Jenkins without a password prompt.

**1. Create a secure sudoers file:**

```bash
sudo visudo -f /etc/sudoers.d/jenkins-restart

```

**2. Add the following line exactly:**
This allows the `ubuntu` user to run *only* the restart command without a password.

```text
ubuntu ALL=(ALL) NOPASSWD: /bin/systemctl restart jenkins

```

**3. Save and set permissions:**

```bash
# Save the file (Ctrl+O, Enter, Ctrl+X)
# Then restrict file permissions for security:
sudo chmod 440 /etc/sudoers.d/jenkins-restart

```

**4. Verify it works:**
Run this command as your normal user. If it runs **without** asking for a password, you are ready.

```bash
sudo systemctl restart jenkins

```

---

## ⏰ Automation (Cron Job)

Set the script to run every minute to ensure maximum uptime.

1. Open your crontab:
```bash
crontab -e

```


2. Add this line to the bottom of the file:
```bash
* * * * * /home/ubuntu/jenkins-health-alert/jenkins-health-alert.sh

```



---

## 🧪 How to Test

1. **Stop Jenkins manually:**
```bash
sudo systemctl stop jenkins

```


2. **Wait 1-2 minutes.**
3. **Check your Email:** You should receive a "Down" alert followed shortly by a "Recovered" alert.
4. **Check the logs:**
```bash
cat ~/jenkins-health.log

```



## 📝 Log Example

```text
Tue Dec 23 18:30:01 IST 2025 | Jenkins status: active
Tue Dec 23 18:31:01 IST 2025 | Jenkins status: failed
Tue Dec 23 18:31:01 IST 2025 | Alert email sent
Tue Dec 23 18:31:12 IST 2025 | Jenkins recovered successfully

```
