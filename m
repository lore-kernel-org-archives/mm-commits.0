From: akpm@linux-foundation.org
Subject: - asix-add-support-for-cables-to-go-usb-ethernet-adapter.patch removed from -mm tree
Date: Fri, 14 Nov 2008 11:23:00 -0800
Message-ID: <200811141923.mAEJN0QW030976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYKNTXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 14:23:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason@lakedaemon.net, mm-commits@vger.kernel.org


The patch titled
     asix: add support for Cables-to-Go USB Ethernet adapter
has been removed from the -mm tree.  Its filename was
     asix-add-support-for-cables-to-go-usb-ethernet-adapter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asix: add support for Cables-to-Go USB Ethernet adapter
From: Jason Cooper <jason@lakedaemon.net>

Add support to drivers/net/usb/asix.c for the Cables-to-Go "USB 2.0 to
10/100 Ethernet Adapter". USB id 0b95:772a.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/net/usb/asix.c~asix-add-support-for-cables-to-go-usb-ethernet-adapter drivers/net/usb/asix.c
--- a/drivers/net/usb/asix.c~asix-add-support-for-cables-to-go-usb-ethernet-adapter
+++ a/drivers/net/usb/asix.c
@@ -1444,6 +1444,10 @@ static const struct usb_device_id	produc
 	// Apple USB Ethernet Adapter
 	USB_DEVICE(0x05ac, 0x1402),
 	.driver_info = (unsigned long) &ax88772_info,
+}, {
+	// Cables-to-Go USB Ethernet Adapter
+	USB_DEVICE(0x0b95, 0x772a),
+	.driver_info = (unsigned long) &ax88772_info,
 },
 	{ },		// END
 };
_

Patches currently in -mm which might be from jason@lakedaemon.net are

linux-next.patch

