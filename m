From: akpm@linux-foundation.org
Subject: - usb-remove-redundant-memset-from-amd5536udc.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:48 -0700
Message-ID: <200708201913.l7KJDmdg018478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757699AbXHTTVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: remove redundant memset from amd5536udc
has been removed from the -mm tree.  Its filename was
     usb-remove-redundant-memset-from-amd5536udc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: remove redundant memset from amd5536udc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Remove redundant memset() call from udc_pci_probe().  No functional change.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/amd5536udc.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/usb/gadget/amd5536udc.c~usb-remove-redundant-memset-from-amd5536udc drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c~usb-remove-redundant-memset-from-amd5536udc
+++ a/drivers/usb/gadget/amd5536udc.c
@@ -3244,7 +3244,6 @@ static int udc_pci_probe(
 		retval = -ENOMEM;
 		goto finished;
 	}
-	memset(dev, 0, sizeof(struct udc));
 
 	/* pci setup */
 	if (pci_enable_device(pdev) < 0) {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
