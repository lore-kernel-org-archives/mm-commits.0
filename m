From: akpm@linux-foundation.org
Subject: - ata_busy_wait-kerneldoc-fixes.patch removed from -mm tree
Date: Fri, 02 Feb 2007 13:38:11 -0800
Message-ID: <200702022138.l12LcBBj018581@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41593 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946124AbXBBViW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 16:38:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ata_busy_wait() kerneldoc fixes
has been removed from the -mm tree.  Its filename was
     ata_busy_wait-kerneldoc-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata_busy_wait() kerneldoc fixes
From: Alan <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/libata.h |    2 ++
 1 files changed, 2 insertions(+)

diff -puN include/linux/libata.h~ata_busy_wait-kerneldoc-fixes include/linux/libata.h
--- a/include/linux/libata.h~ata_busy_wait-kerneldoc-fixes
+++ a/include/linux/libata.h
@@ -1047,6 +1047,8 @@ static inline void ata_pause(struct ata_
 /**
  *	ata_busy_wait - Wait for a port status register
  *	@ap: Port to wait for.
+ *	@bits: bits that must be clear
+ *	@max: number of 10uS waits to perform
  *
  *	Waits up to max*10 microseconds for the selected bits in the port's
  *	status register to be cleared.
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
sis-warning-fixes.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
git-mtd.patch
z85230-spinlock-logic.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
geode-support-classic-mediagxm.patch
cyrix-fails-to-detect-mediagx.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
sched-avoid-div-in-rebalance_tick.patch
pm3fb-kill-pci_find_device-usage.patch
