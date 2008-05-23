From: akpm@linux-foundation.org
Subject: - net-usb-add-support-for-apple-usb-ethernet-adapter.patch removed from -mm tree
Date: Fri, 23 May 2008 11:58:54 -0700
Message-ID: <200805231858.m4NIwsqs004185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756275AbYEWS7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien.nephtali@sitadelle.com, aurelien@sitadelle.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     net/usb: add support for Apple USB Ethernet Adapter
has been removed from the -mm tree.  Its filename was
     net-usb-add-support-for-apple-usb-ethernet-adapter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/usb: add support for Apple USB Ethernet Adapter
From: Aurelien Nephtali <aurelien.nephtali@sitadelle.com>

Add support for Apple USB Ethernet Adapter.

http://store.apple.com/1-800-MY-APPLE/WebObjects/AppleStore.woa/wa/RSLID?nplm=MB442Z/A

Signed-off-by: Aurelien Nephtali <aurelien@sitadelle.com>
Acked-by: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/net/usb/asix.c~net-usb-add-support-for-apple-usb-ethernet-adapter drivers/net/usb/asix.c
--- a/drivers/net/usb/asix.c~net-usb-add-support-for-apple-usb-ethernet-adapter
+++ a/drivers/net/usb/asix.c
@@ -1440,6 +1440,10 @@ static const struct usb_device_id	produc
 	// Belkin F5D5055
 	USB_DEVICE(0x050d, 0x5055),
 	.driver_info = (unsigned long) &ax88178_info,
+}, {
+	// Apple USB Ethernet Adapter
+	USB_DEVICE(0x05ac, 0x1402),
+	.driver_info = (unsigned long) &ax88772_info,
 },
 	{ },		// END
 };
_

Patches currently in -mm which might be from aurelien.nephtali@sitadelle.com are

git-net.patch

