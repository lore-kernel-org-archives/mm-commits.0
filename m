From: akpm@osdl.org
Subject: - remove-drivers-char-riscom8cbaud_table.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:59 -0800
Message-ID: <200612072315.kB7NFx6u030769@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54088 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163915AbWLGXTM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     remove drivers/char/riscom8.c:baud_table[]
has been removed from the -mm tree.  Its filename was
     remove-drivers-char-riscom8cbaud_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove drivers/char/riscom8.c:baud_table[]
From: Adrian Bunk <bunk@stusta.de>

Commit c7bce3097c0f9bbed76ee6fd03742f2624031a45 removed all usages of
baud_table[] but not the array itself.

Spotted by the GNU C compiler.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/riscom8.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/char/riscom8.c~remove-drivers-char-riscom8cbaud_table drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~remove-drivers-char-riscom8cbaud_table
+++ a/drivers/char/riscom8.c
@@ -82,11 +82,6 @@
 static struct riscom_board * IRQ_to_board[16];
 static struct tty_driver *riscom_driver;
 
-static unsigned long baud_table[] =  {
-	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
-	9600, 19200, 38400, 57600, 76800, 0, 
-};
-
 static struct riscom_board rc_board[RC_NBOARD] =  {
 	{
 		.base	= RC_IOBASE1,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

