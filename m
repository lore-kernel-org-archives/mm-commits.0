From: akpm@linux-foundation.org
Subject: [merged] sis-usb2vga-driver-support-kairens-usb-vga-adaptor-usb20svga-mb-plus.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:17:14 -0800
Message-ID: <201001292017.o0TKHE4J003293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857Ab0A2UR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akr@fsij.org, gregkh@suse.de, thomas@winischhofer.net, mm-commits@vger.kernel.org


The patch titled
     SIS USB2VGA DRIVER: support KAIREN's USB VGA adaptor USB20SVGA-MB-PLUS
has been removed from the -mm tree.  Its filename was
     sis-usb2vga-driver-support-kairens-usb-vga-adaptor-usb20svga-mb-plus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SIS USB2VGA DRIVER: support KAIREN's USB VGA adaptor USB20SVGA-MB-PLUS
From: Tanaka Akira <akr@fsij.org>

Add the USB product ID of KAIREN's USB VGA Adaptor, USB20SVGA-MB-PLUS, to
make sisusbvga work with it.

Signed-off-by: Tanaka Akira <akr@fsij.org>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/misc/sisusbvga/sisusb.c~sis-usb2vga-driver-support-kairens-usb-vga-adaptor-usb20svga-mb-plus drivers/usb/misc/sisusbvga/sisusb.c
--- a/drivers/usb/misc/sisusbvga/sisusb.c~sis-usb2vga-driver-support-kairens-usb-vga-adaptor-usb20svga-mb-plus
+++ a/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3255,6 +3255,7 @@ static const struct usb_device_id sisusb
 	{ USB_DEVICE(0x0711, 0x0902) },
 	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
+	{ USB_DEVICE(0x0711, 0x0920) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }
_

Patches currently in -mm which might be from akr@fsij.org are

linux-next.patch

