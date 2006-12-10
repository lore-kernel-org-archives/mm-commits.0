From: akpm@osdl.org
Subject: + ia64-enable-config_debug_spinlock_sleep.patch added to -mm tree
Date: Sun, 10 Dec 2006 14:11:59 -0800
Message-ID: <200612102211.kBAMBxQi004754@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40596 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758430AbWLJWMF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 17:12:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, tony.luck@intel.com


The patch titled
     ia64: enable config_debug_spinlock_sleep
has been added to the -mm tree.  Its filename is
     ia64-enable-config_debug_spinlock_sleep.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: enable config_debug_spinlock_sleep
From: Andrew Morton <akpm@osdl.org>

Some trivial bugs are coming from ia64 developers.  Try to help them.

Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/configs/bigsur_defconfig    |    2 +-
 arch/ia64/configs/gensparse_defconfig |    2 +-
 arch/ia64/configs/sim_defconfig       |    2 +-
 arch/ia64/configs/sn2_defconfig       |    2 +-
 arch/ia64/configs/tiger_defconfig     |    4 ++--
 arch/ia64/configs/zx1_defconfig       |    2 +-
 arch/ia64/defconfig                   |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/ia64/configs/bigsur_defconfig~ia64-enable-config_debug_spinlock_sleep arch/ia64/configs/bigsur_defconfig
--- a/arch/ia64/configs/bigsur_defconfig~ia64-enable-config_debug_spinlock_sleep
+++ a/arch/ia64/configs/bigsur_defconfig
@@ -1305,7 +1305,7 @@ CONFIG_DETECT_SOFTLOCKUP=y
 CONFIG_DEBUG_PREEMPT=y
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_DEBUG_KOBJECT is not set
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
diff -puN arch/ia64/configs/sim_defconfig~ia64-enable-config_debug_spinlock_sleep arch/ia64/configs/sim_defconfig
--- a/arch/ia64/configs/sim_defconfig~ia64-enable-config_debug_spinlock_sleep
+++ a/arch/ia64/configs/sim_defconfig
@@ -694,7 +694,7 @@ CONFIG_DETECT_SOFTLOCKUP=y
 CONFIG_DEBUG_PREEMPT=y
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_DEBUG_KOBJECT is not set
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
diff -puN arch/ia64/configs/sn2_defconfig~ia64-enable-config_debug_spinlock_sleep arch/ia64/configs/sn2_defconfig
--- a/arch/ia64/configs/sn2_defconfig~ia64-enable-config_debug_spinlock_sleep
+++ a/arch/ia64/configs/sn2_defconfig
@@ -1284,7 +1284,7 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_SPINLOCK is not set
 # CONFIG_DEBUG_MUTEXES is not set
 # CONFIG_DEBUG_RWSEMS is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
 CONFIG_DEBUG_INFO=y
diff -puN arch/ia64/configs/tiger_defconfig~ia64-enable-config_debug_spinlock_sleep arch/ia64/configs/tiger_defconfig
--- a/arch/ia64/configs/tiger_defconfig~ia64-enable-config_debug_spinlock_sleep
+++ a/arch/ia64/configs/tiger_defconfig
@@ -1,4 +1,4 @@
-#
+;#
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.16-rc5
 # Mon Feb 27 15:49:18 2006
@@ -1190,7 +1190,7 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_SLAB is not set
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_DEBUG_KOBJECT is not set
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
diff -puN arch/ia64/configs/zx1_defconfig~ia64-enable-config_debug_spinlock_sleep arch/ia64/configs/zx1_defconfig
--- a/arch/ia64/configs/zx1_defconfig~ia64-enable-config_debug_spinlock_sleep
+++ a/arch/ia64/configs/zx1_defconfig
@@ -1359,7 +1359,7 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_SLAB is not set
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_DEBUG_KOBJECT is not set
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
diff -puN arch/ia64/configs/gensparse_defconfig~ia64-enable-config_debug_spinlock_sleep arch/ia64/configs/gensparse_defconfig
--- a/arch/ia64/configs/gensparse_defconfig~ia64-enable-config_debug_spinlock_sleep
+++ a/arch/ia64/configs/gensparse_defconfig
@@ -1339,7 +1339,7 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_SLAB is not set
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_DEBUG_KOBJECT is not set
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
diff -puN arch/ia64/defconfig~ia64-enable-config_debug_spinlock_sleep arch/ia64/defconfig
--- a/arch/ia64/defconfig~ia64-enable-config_debug_spinlock_sleep
+++ a/arch/ia64/defconfig
@@ -1339,7 +1339,7 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_SLAB is not set
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_DEBUG_KOBJECT is not set
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
submit-checklist-update.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
sched-add-option-to-serialize-load-balancing.patch
kernel-schedc-whitespace-cleanups.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
round_jiffies-infrastructure.patch
clocksource-small-cleanup-2.patch
kvm-userspace-interface.patch
x86-smp-export-smp_num_siblings-for-oprofile.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
alsa-workqueue-fixes.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
platform_driver_probe-can-save-codespace-save-codespace.patch
git-dvb.patch
git-dvb-fixup.patch
git-input-vs-git-alsa.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-net.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
git-ocfs2-fixup.patch
pci-fix-multiple-problems-with-via-hardware.patch
pci-legacy-resource-fix-tidy.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
revert-git-block.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
touchkit-ps-2-touchscreen-driver.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
congestion-wait-dont-wait-when-there-are-no-pages-under-writeback.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
ia64-enable-config_debug_spinlock_sleep.patch

