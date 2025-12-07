SRC_DIR := "/home/salmay/Desktop/compu/TERMS/term7/OS/LABS/lab1/SCR_TRIAL"
BACKUP_DIR := "/home/salmay/Desktop/compu/TERMS/term7/OS/LABS/lab1/BACKUP_TRIAL"

INTERVAL := 3
MAX_BACKUPS := 3
BACKUP_SCRIPT := ./backupd.sh
RESTORE_SCRIPT := ./restore.sh
CRON_SCRIPT := ./backupd-cron.sh
CRON_BACKUP_DIR := "/home/salmay/Desktop/compu/TERMS/term7/OS/LABS/lab1/BACKUP_TRIAL_CRON"

all:
	@echo "Use 'make backup', 'make restore', or 'make cron-backup' or 'make cron-remove'."

backup:
	@mkdir -p "$(BACKUP_DIR)"
	@bash "$(BACKUP_SCRIPT)" "$(SRC_DIR)" "$(BACKUP_DIR)" $(INTERVAL) $(MAX_BACKUPS)

restore:
	@if [ ! -d "$(BACKUP_DIR)" ]; then \
		echo "Backup directory does not exist"; \
		exit 1; \
	fi
	@bash "$(RESTORE_SCRIPT)" "$(SRC_DIR)" "$(BACKUP_DIR)"

cron-backup:
	@mkdir -p "$(CRON_BACKUP_DIR)"
	@bash "$(CRON_SCRIPT)"
	
cron-remove:
	@echo "Stopping any running cron backup script..."
	@pkill -f "$(CRON_SCRIPT)" || echo "No cron backup process running."
