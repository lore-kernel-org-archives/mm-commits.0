From: akpm@linux-foundation.org
Subject: - ia64-enable-config_debug_spinlock_sleep.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:55:39 -0800
Message-ID: <200703152155.l2FLtdum027500@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42214 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXCOV4C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: enable CONFIG_DEBUG_SPINLOCK_SLEEP
has been removed from the -mm tree.  Its filename was
     ia64-enable-config_debug_spinlock_sleep.patch

This patch was dropped because it got lots of rejects

------------------------------------------------------
Subject: ia64: enable CONFIG_DEBUG_SPINLOCK_SLEEP
From: Andrew Morton <akpm@osdl.org>

Some trivial bugs are coming from ia64 developers.  Try to help them.

Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
diff -puN arch/ia64/defconfig~ia64-enable-config_debug_spinlock_sleep arch/ia64/defconfig
--- a/arch/ia64/defconfig~ia64-enable-config_debug_spinlock_sleep
+++ a/arch/ia64/defconfig
@@ -1340,7 +1340,7 @@ CONFIG_DETECT_SOFTLOCKUP=y
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

git-powerpc.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
epoll-optimizations-and-cleanups-tidy.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
