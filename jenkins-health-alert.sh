#!/bin/bash
# This script checks Jenkins service status.
# If Jenkins is down:
#   1. Send alert email
#   2. Restart Jenkins
#   3. Send recovery email if restart succeeds

# -----------------------------
# BASIC CONFIGURATION
# -----------------------------

SERVICE="jenkins"                            # Jenkins service name
EMAILS="prajwalgowda112001@gmail.com"         # Email to receive alerts
LOGFILE="$HOME/jenkins-health-alert/jenkins-health.log"            # Single log file

# Create log file if it does not exist
touch "$LOGFILE"

# Redirect ALL output and ALL errors to the log file
# From this line onwards, everything is written into jenkins-health.log
exec >> "$LOGFILE" 2>&1

# -----------------------------
# SYSTEM INFORMATION
# -----------------------------

HOSTNAME=$(hostname)                          # Server hostname
CURRENT_TIME=$(date)                          # Current date and time
JENKINS_VERSION=$(jenkins --version 2>/dev/null)  # Jenkins version (hide errors)

# -----------------------------
# CHECK JENKINS STATUS
# -----------------------------

JENKINS_STATUS=$(systemctl is-active $SERVICE)

# Log Jenkins status every time script runs
echo "$CURRENT_TIME | Jenkins status: $JENKINS_STATUS" >> "$LOGFILE"

# -----------------------------
# IF JENKINS IS DOWN
# -----------------------------

if [[ "$JENKINS_STATUS" != "active" ]]; then

  # Send CRITICAL alert email
  printf "Jenkins is DOWN\n\nHost: %s\nStatus: %s\nVersion: %s\nTime: %s\n" \
  "$HOSTNAME" "$JENKINS_STATUS" "$JENKINS_VERSION" "$CURRENT_TIME" | \
  mail -s "CRITICAL ALERT: Jenkins DOWN on $HOSTNAME" $EMAILS

  # Log alert event
  echo "$CURRENT_TIME | Alert email sent" >> "$LOGFILE"

  # -----------------------------
  # AUTO-HEALING: RESTART JENKINS
  # -----------------------------

  sudo systemctl restart $SERVICE
  sleep 10   # Wait for Jenkins to start

  # Recheck Jenkins status after restart
  NEW_STATUS=$(systemctl is-active $SERVICE)

  # -----------------------------
  # IF JENKINS IS RECOVERED
  # -----------------------------

  if [[ "$NEW_STATUS" == "active" ]]; then

    # Send recovery email
    printf "Jenkins is RECOVERED\n\nHost: %s\nStatus: %s\nTime: %s\n" \
    "$HOSTNAME" "$NEW_STATUS" "$(date)" | \
    mail -s "RECOVERY ALERT: Jenkins UP on $HOSTNAME" $EMAILS

    # Log recovery event
    echo "$(date) | Jenkins recovered successfully" >> "$LOGFILE"
  fi
fi

