From: akpm@linux-foundation.org
Subject: - sisusb2vga-driver-add-0x0711-0x0903.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:28:02 -0800
Message-ID: <200811132128.mADLS2IB028251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbYKMV23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:28:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albert@ecm.ub.es, alan@lxorguk.ukuu.org.uk, albert.comerma@gmail.com, david-b@pacbell.net, greg@kroah.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     SISUSB2VGA driver: add 0x0711, 0x0903
has been removed from the -mm tree.  Its filename was
     sisusb2vga-driver-add-0x0711-0x0903.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SISUSB2VGA driver: add 0x0711, 0x0903
From: Albert Comerma <albert@ecm.ub.es>

Signed-off-by: Albert Comerma <albert.comerma@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Brownell <david-b@pacbell.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/misc/sisusbvga/sisusb.c~sisusb2vga-driver-add-0x0711-0x0903 drivers/usb/misc/sisusbvga/sisusb.c
--- a/drivers/usb/misc/sisusbvga/sisusb.c~sisusb2vga-driver-add-0x0711-0x0903
+++ a/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3270,6 +3270,7 @@ static struct usb_device_id sisusb_table
 	{ USB_DEVICE(0x0711, 0x0900) },
 	{ USB_DEVICE(0x0711, 0x0901) },
 	{ USB_DEVICE(0x0711, 0x0902) },
+	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
_

Patches currently in -mm which might be from albert@ecm.ub.es are

linux-next.patch

