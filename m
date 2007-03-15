From: akpm@linux-foundation.org
Subject: - ata_piix-remove-ugly-layering-violation.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:18 -0800
Message-ID: <200703152158.l2FLwII5027721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42480 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbXCOV6h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata_piix: remove ugly layering violation
has been removed from the -mm tree.  Its filename was
     ata_piix-remove-ugly-layering-violation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata_piix: remove ugly layering violation
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

A while ago I modified the libata code so that drivers can return -ENOENT for
unknown ports not fiddle with the EH flags and print stuff directly. 
Somewhere along the line ata_piix didn't get fully converted.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/ata_piix.c~ata_piix-remove-ugly-layering-violation drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata_piix-remove-ugly-layering-violation
+++ a/drivers/ata/ata_piix.c
@@ -93,7 +93,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"ata_piix"
-#define DRV_VERSION	"2.10"
+#define DRV_VERSION	"2.10ac1"
 
 enum {
 	PIIX_IOCFG		= 0x54, /* IDE I/O configuration register */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
