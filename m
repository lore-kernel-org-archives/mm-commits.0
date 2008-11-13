From: akpm@linux-foundation.org
Subject: + asix-add-support-for-cables-to-go-usb-ethernet-adapter.patch added to -mm tree
Date: Thu, 13 Nov 2008 14:32:05 -0800
Message-ID: <200811132232.mADMW5jo027868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbYKMWcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 17:32:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason@lakedaemon.net


The patch titled
     asix: add support for Cables-to-Go USB Ethernet adapter
has been added to the -mm tree.  Its filename is
     asix-add-support-for-cables-to-go-usb-ethernet-adapter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

asix-add-support-for-cables-to-go-usb-ethernet-adapter.patch

