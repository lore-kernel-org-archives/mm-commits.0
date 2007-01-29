From: akpm@osdl.org
Subject: + pl2303-willcom-ws002in-support.patch added to -mm tree
Date: Sun, 28 Jan 2007 16:00:09 -0800
Message-ID: <200701290000.l0T0099L006513@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbXA2AAN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 19:00:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoshfuji@linux-ipv6.org, greg@kroah.com


The patch titled
     usbserial: PL2303: Willcom WS002IN Support
has been added to the -mm tree.  Its filename is
     pl2303-willcom-ws002in-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usbserial: PL2303: Willcom WS002IN Support
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    5 +++++
 2 files changed, 6 insertions(+)

diff -puN drivers/usb/serial/pl2303.c~pl2303-willcom-ws002in-support drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~pl2303-willcom-ws002in-support
+++ a/drivers/usb/serial/pl2303.c
@@ -83,6 +83,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(BELKIN_VENDOR_ID, BELKIN_PRODUCT_ID) },
 	{ USB_DEVICE(ALCOR_VENDOR_ID, ALCOR_PRODUCT_ID) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ID) },
+	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
diff -puN drivers/usb/serial/pl2303.h~pl2303-willcom-ws002in-support drivers/usb/serial/pl2303.h
--- a/drivers/usb/serial/pl2303.h~pl2303-willcom-ws002in-support
+++ a/drivers/usb/serial/pl2303.h
@@ -97,3 +97,8 @@
 /* Huawei E620 UMTS/HSDPA card (ID: 12d1:1001) */
 #define HUAWEI_VENDOR_ID	0x12d1
 #define HUAWEI_PRODUCT_ID	0x1001
+
+/* Willcom WS002IN Data Driver (by NetIndex Inc.) */
+#define WS002IN_VENDOR_ID	0x11f6
+#define WS002IN_PRODUCT_ID	0x2001
+
_

Patches currently in -mm which might be from yoshfuji@linux-ipv6.org are

pl2303-willcom-ws002in-support.patch
