From: akpm@linux-foundation.org
Subject: - pata_triflex-cable-detect.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:48:36 -0800
Message-ID: <200703072348.l27NmasC013439@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39329 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbXCGXsw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:48:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_triflex: cable detect
has been removed from the -mm tree.  Its filename was
     pata_triflex-cable-detect.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pata_triflex: cable detect
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_triflex.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/ata/pata_triflex.c~pata_triflex-cable-detect drivers/ata/pata_triflex.c
--- a/drivers/ata/pata_triflex.c~pata_triflex-cable-detect
+++ a/drivers/ata/pata_triflex.c
@@ -43,7 +43,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_triflex"
-#define DRV_VERSION "0.2.7"
+#define DRV_VERSION "0.2.8"
 
 /**
  *	triflex_prereset		-	probe begin
@@ -215,6 +215,7 @@ static struct ata_port_operations trifle
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= triflex_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= triflex_bmdma_start,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
pata_sl82c105-missing-methods-cable.patch
ata_piix-remove-ugly-layering-violation.patch
pata_triflex-cable-detect.patch
pata_cmd640-multiple-updates.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
dilnetpc-fix-warning.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
z85230-fix-fifo-handling.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
