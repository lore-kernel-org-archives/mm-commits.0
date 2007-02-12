From: akpm@linux-foundation.org
Subject: - cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:26:15 -0800
Message-ID: <200702120726.l1C7QFfA024789@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44979 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933066AbXBLH3r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:29:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@pol.net, jsimmons@infradead.org, ralf@linux-mips.org, woodys@xandros.com, mm-commits@vger.kernel.org


The patch titled
     cyber2010-framebuffer-on-arm-netwinder-fix-tidy
has been removed from the -mm tree.  Its filename was
     cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch

This patch was dropped because it was folded into cyber2010-framebuffer-on-arm-netwinder-fix.patch

------------------------------------------------------
Subject: cyber2010-framebuffer-on-arm-netwinder-fix-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Woody Suwalski <woodys@xandros.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cyber2000fb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/cyber2000fb.c~cyber2010-framebuffer-on-arm-netwinder-fix-tidy drivers/video/cyber2000fb.c
--- a/drivers/video/cyber2000fb.c~cyber2010-framebuffer-on-arm-netwinder-fix-tidy
+++ a/drivers/video/cyber2000fb.c
@@ -1539,12 +1539,9 @@ static int cyberpro_pci_enable_mmio(stru
 	/*
 	 * Allow the CyberPro to accept PCI burst accesses
 	 */
-	if (cfb->id == ID_CYBERPRO_2010)
-	{
+	if (cfb->id == ID_CYBERPRO_2010) {
 		printk(KERN_INFO "%s: NOT enabling PCI bursts\n", cfb->fb.fix.id);
-	}
-	else
-	{
+	} else {
 		val = cyber2000_grphr(EXT_BUS_CTL, cfb);
 		if (!(val & EXT_BUS_CTL_PCIBURST_WRITE)) {
 			printk(KERN_INFO "%s: enabling PCI bursts\n",
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-generalize-metadata-read-write.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
cyber2010-framebuffer-on-arm-netwinder-fix.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
