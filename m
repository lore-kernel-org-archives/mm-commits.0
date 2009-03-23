From: akpm@linux-foundation.org
Subject: + uvc-add-entry-for-logitech-quickcam-orbit-af.patch added to -mm tree
Date: Sun, 22 Mar 2009 17:59:40 -0700
Message-ID: <200903230103.n2N13wK4001412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720AbZCWBIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Mar 2009 21:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: robbat2@orbis-terrarum.net, laurent.pinchart@skynet.be, mchehab@infradead.org


The patch titled
     uvc: add entry for Logitech Quickcam Orbit AF
has been added to the -mm tree.  Its filename is
     uvc-add-entry-for-logitech-quickcam-orbit-af.patch

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
Subject: uvc: add entry for Logitech Quickcam Orbit AF
From: "Robin H. Johnson" <robbat2@orbis-terrarum.net>

Need explicit entry like many of the other Logitech devices as it does not
match the class otherwise.

Signed-off-by: Robin H. Johnson <robbat2@orbis-terrarum.net>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/uvc/uvc_driver.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/media/video/uvc/uvc_driver.c~uvc-add-entry-for-logitech-quickcam-orbit-af drivers/media/video/uvc/uvc_driver.c
--- a/drivers/media/video/uvc/uvc_driver.c~uvc-add-entry-for-logitech-quickcam-orbit-af
+++ a/drivers/media/video/uvc/uvc_driver.c
@@ -1801,6 +1801,14 @@ static struct usb_device_id uvc_ids[] = 
 	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0 },
+	/* Logitech Quickcam Orbit AF */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x0994,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
 	/* Logitech Quickcam Pro for Notebook */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
_

Patches currently in -mm which might be from robbat2@orbis-terrarum.net are

uvc-add-entry-for-logitech-quickcam-orbit-af.patch

