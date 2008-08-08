From: akpm@linux-foundation.org
Subject: - usb-bandrich-bandluxe-c150-c250-hspa-data-card-driver.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:08:29 -0700
Message-ID: <200808082208.m78M8TlY031255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764103AbYHHWM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:12:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: upleong@bandrich.com, greg@kroah.com, smurf@smurf.noris.de, mm-commits@vger.kernel.org


The patch titled
     usb: BandRich BandLuxe C150/C250 HSPA Data Card Driver
has been removed from the -mm tree.  Its filename was
     usb-bandrich-bandluxe-c150-c250-hspa-data-card-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: BandRich BandLuxe C150/C250 HSPA Data Card Driver
From: Leon Leong <upleong@bandrich.com>

Add the Product ID for the BandLuxe C150/C250 3.5G data card series from
BandRich Inc.  After detection, the data card works fine.

Signed-off-by: Leon Leong <upleong@bandrich.com>
Cc: Matthias Urlichs <smurf@smurf.noris.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff -puN drivers/usb/serial/option.c~usb-bandrich-bandluxe-c150-c250-hspa-data-card-driver drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-bandrich-bandluxe-c150-c250-hspa-data-card-driver
+++ a/drivers/usb/serial/option.c
@@ -186,6 +186,23 @@ static int  option_send_setup(struct tty
 #define BANDRICH_VENDOR_ID			0x1A8D
 #define BANDRICH_PRODUCT_C100_1			0x1002
 #define BANDRICH_PRODUCT_C100_2			0x1003
+#define BANDRICH_PRODUCT_1004			0x1004
+#define BANDRICH_PRODUCT_1005			0x1005
+#define BANDRICH_PRODUCT_1006			0x1006
+#define BANDRICH_PRODUCT_1007			0x1007
+#define BANDRICH_PRODUCT_1008			0x1008
+#define BANDRICH_PRODUCT_1009			0x1009
+#define BANDRICH_PRODUCT_100A			0x100a
+
+#define BANDRICH_PRODUCT_100B			0x100b
+#define BANDRICH_PRODUCT_100C			0x100c
+#define BANDRICH_PRODUCT_100D			0x100d
+#define BANDRICH_PRODUCT_100E			0x100e
+
+#define BANDRICH_PRODUCT_100F			0x100f
+#define BANDRICH_PRODUCT_1010			0x1010
+#define BANDRICH_PRODUCT_1011			0x1011
+#define BANDRICH_PRODUCT_1012			0x1012
 
 #define AMOI_VENDOR_ID			0x1614
 #define AMOI_PRODUCT_9508			0x0800
@@ -302,6 +319,21 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_ET502HS) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1004) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1005) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1006) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1007) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1008) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1009) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100A) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100B) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100C) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100D) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100E) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100F) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1010) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1011) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1012) },
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC650) },
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
_

Patches currently in -mm which might be from upleong@bandrich.com are

linux-next.patch

