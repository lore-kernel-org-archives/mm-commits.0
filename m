From: akpm@linux-foundation.org
Subject: - mips-convert-to-use-shared-apm-emulation-fix.patch removed from -mm tree
Date: Wed, 02 May 2007 20:45:18 -0700
Message-ID: <200705030345.l433jIRo004181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945967AbXECDp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 23:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips-convert-to-use-shared-apm-emulation-fix
has been removed from the -mm tree.  Its filename was
     mips-convert-to-use-shared-apm-emulation-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mips-convert-to-use-shared-apm-emulation-fix
From: Andrew Morton <akpm@osdl.org>

arch/mips/Kconfig:2059: unexpected end statement
arch/mips/Kconfig:2061: missing end statement for this entry

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/mips/Kconfig~mips-convert-to-use-shared-apm-emulation-fix arch/mips/Kconfig
--- a/arch/mips/Kconfig~mips-convert-to-use-shared-apm-emulation-fix
+++ a/arch/mips/Kconfig
@@ -2132,10 +2132,6 @@ config BINFMT_ELF32
 	bool
 	default y if MIPS32_O32 || MIPS32_N32
 
-endmenu
-
-menu "Power management options"
-
 source "kernel/power/Kconfig"
 
 endmenu
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-ia64.patch
git-ieee1394.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
epoll-optimizations-and-cleanups.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work.patch
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
ext2-reservations.patch
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
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
