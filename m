From: akpm@linux-foundation.org
Subject: + kconfig-clarify-ata_piix-description.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:52:31 -0800
Message-ID: <200702052252.l15MqV1N001735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964894AbXBEWwt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:52:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     Kconfig: clarify ATA_PIIX description
has been added to the -mm tree.  Its filename is
     kconfig-clarify-ata_piix-description.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kconfig: clarify ATA_PIIX description
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

People are getting confused about which drivers to enable for PATA PIIX type
devices.  Change the ATA_PIIX line and help to make it clearer.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/ata/Kconfig~kconfig-clarify-ata_piix-description drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~kconfig-clarify-ata_piix-description
+++ a/drivers/ata/Kconfig
@@ -41,12 +41,12 @@ config SATA_SVW
 	  If unsure, say N.
 
 config ATA_PIIX
-	tristate "Intel PIIX/ICH SATA support"
+	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
 	depends on PCI
 	help
 	  This option enables support for ICH5/6/7/8 Serial ATA
-	  and support for PATA on the Intel PIIX3/PIIX4/ICH series
-	  PATA host controllers.
+	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
+	  host controllers.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
sis-warning-fixes.patch
kconfig-clarify-ata_piix-description.patch
ata-add-defines-for-the-iordy-bits.patch
libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
libata-early-cfa-adapters-are-not-required-to-support-mode.patch
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
geode-configuration-fixes.patch
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
