From: akpm@linux-foundation.org
Subject: - usb-speedtchc-fix-sparse-shadowed-variable-warning.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:28 -0700
Message-ID: <200806122037.m5CKbS58005428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757610AbYFLUhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, baldrick@free.fr, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: speedtch.c fix sparse shadowed variable warning
has been removed from the -mm tree.  Its filename was
     usb-speedtchc-fix-sparse-shadowed-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: speedtch.c fix sparse shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>

i is used only as a for-loop index no need to declare another.
drivers/usb/atm/speedtch.c:832:7: warning: symbol 'i' shadows an earlier one
drivers/usb/atm/speedtch.c:766:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg KH <greg@kroah.com>
Reviewed-by: Duncan Sands <baldrick@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/speedtch.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/usb/atm/speedtch.c~usb-speedtchc-fix-sparse-shadowed-variable-warning drivers/usb/atm/speedtch.c
--- a/drivers/usb/atm/speedtch.c~usb-speedtchc-fix-sparse-shadowed-variable-warning
+++ a/drivers/usb/atm/speedtch.c
@@ -829,7 +829,6 @@ static int speedtch_bind(struct usbatm_d
 	if (use_isoc) {
 		const struct usb_host_interface *desc = data_intf->cur_altsetting;
 		const __u8 target_address = USB_DIR_IN | usbatm->driver->isoc_in;
-		int i;
 
 		use_isoc = 0; /* fall back to bulk if endpoint not found */
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

