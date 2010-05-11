From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 11 May 2010 14:02:34 -0700
Message-ID: <201005112130.o4BLUIp4024035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776Ab0EKVaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 17:30:22 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o4BLUJcI031241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 11 May 2010 14:30:20 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep.c |   91 -----------------------------------------
 net/ipv4/ipmr.c      |    9 +---
 2 files changed, 3 insertions(+), 97 deletions(-)

diff -puN drivers/acpi/sleep.c~linux-next-git-rejects drivers/acpi/sleep.c
--- a/drivers/acpi/sleep.c~linux-next-git-rejects
+++ a/drivers/acpi/sleep.c
@@ -382,97 +382,6 @@ static struct dmi_system_id __initdata a
 		},
 	},
 	{
-<<<<<<< HEAD
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Toshiba Satellite L300",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Satellite L300"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Hewlett-Packard HP G7000 Notebook PC",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP G7000 Notebook PC"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Hewlett-Packard HP Pavilion dv3 Notebook PC",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv3 Notebook PC"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Hewlett-Packard Pavilion dv4",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Hewlett-Packard Pavilion dv7",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv7"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Hewlett-Packard Compaq Presario C700 Notebook PC",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Compaq Presario C700 Notebook PC"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Hewlett-Packard Compaq Presario CQ40 Notebook PC",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "Compaq Presario CQ40 Notebook PC"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T410",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T410"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad W510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201[s]",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
-		},
-	},
-	{
-=======
->>>>>>> FETCH_HEAD
 	.callback = init_old_suspend_ordering,
 	.ident = "Panasonic CF51-2L",
 	.matches = {
diff -puN net/ipv4/ipmr.c~linux-next-git-rejects net/ipv4/ipmr.c
--- a/net/ipv4/ipmr.c~linux-next-git-rejects
+++ a/net/ipv4/ipmr.c
@@ -998,12 +998,9 @@ ipmr_cache_unresolved(struct mr_table *m
 		atomic_inc(&mrt->cache_resolve_queue_len);
 		list_add(&c->list, &mrt->mfc_unres_queue);
 
-<<<<<<< HEAD
-		if (atomic_read(&net->ipv4.cache_resolve_queue_len) == 1)
-			mod_timer(&ipmr_expire_timer, c->mfc_un.unres.expires);
-=======
-		mod_timer(&mrt->ipmr_expire_timer, c->mfc_un.unres.expires);
->>>>>>> FETCH_HEAD
+		if (atomic_read(&mrt->cache_resolve_queue_len) == 1)
+			mod_timer(&mrt->ipmr_expire_timer,
+				  c->mfc_un.unres.expires);
 	}
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-gpu-drm-i915-i915_irqc-i915_error_object_create-use-correct-kmap-atomic-slot.patch
linux-next.patch
linux-next-fix-rejects.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
jfs-free-sbi-memory-in-error-path.patch
dib3000mc-reduce-large-stack-usage-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix-2.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-checkpatch-fixes.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix-fix.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
lib-introduce-common-method-to-convert-hex-digits-fix.patch
lib-introduce-common-method-to-convert-hex-digits-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
s3c-fb-add-s5pv210-support-and-some-features-checkpatch-fixes.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix-2.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs-checkpatch-fixes.patch
pids-increase-pid_max-based-on-num_possible_cpus-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch

