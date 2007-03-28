From: akpm@linux-foundation.org
Subject: - arch-i386-kernel-alternativec-dont-include-bugsh.patch removed from -mm tree
Date: Wed, 28 Mar 2007 11:40:53 -0700
Message-ID: <200703281840.l2SIergw017259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53693 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965587AbXC1SlH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 14:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@muc.de, mm-commits@vger.kernel.org


The patch titled
     arch/i386/kernel/alternative.c: don't include bugs.h
has been removed from the -mm tree.  Its filename was
     arch-i386-kernel-alternativec-dont-include-bugsh.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: arch/i386/kernel/alternative.c: don't include bugs.h
From: Andrew Morton <akpm@osdl.org>

That stupid non-inlined-static function in bugs.h causes:

include/asm/bugs.h:186: warning: 'check_bugs' defined but not used

But fortunately the include isn't needed.

Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/i386/kernel/alternative.c~arch-i386-kernel-alternativec-dont-include-bugsh arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~arch-i386-kernel-alternativec-dont-include-bugsh
+++ a/arch/i386/kernel/alternative.c
@@ -4,7 +4,6 @@
 #include <linux/list.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
-#include <asm/bugs.h>
 
 static int no_replacement    = 0;
 static int smp_alt_once      = 0;
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
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
lumpy-reclaim-v4.patch
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
squash-ipc-warnings.patch
