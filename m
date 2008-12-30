From: akpm@linux-foundation.org
Subject: + drivers-media-video-gspca-vc032xc-add-support-for-gspca-vc032x.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:57:08 -0800
Message-ID: <200812302357.mBUNv8oK023000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbYL3X5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:57:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mail@andreas-demmer.de, mchehab@infradead.org, moinejf@free.fr


The patch titled
     drivers/media/video/gspca/vc032x.c: add support for GSPCA VC032x
has been added to the -mm tree.  Its filename is
     drivers-media-video-gspca-vc032xc-add-support-for-gspca-vc032x.patch

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
Subject: drivers/media/video/gspca/vc032x.c: add support for GSPCA VC032x
From: Andreas Demmer <mail@andreas-demmer.de>

Add support for built-in "Logitech QuickCam for Dell notebooks" webcams.

Add a new USB ID (046d:0897) to the list of supported devices with the
VIMICRO chip.  The hardware seems to be pretty identical to 046d:0896 but
features a different USB ID.

Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/vc032x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/gspca/vc032x.c~drivers-media-video-gspca-vc032xc-add-support-for-gspca-vc032x drivers/media/video/gspca/vc032x.c
--- a/drivers/media/video/gspca/vc032x.c~drivers-media-video-gspca-vc032xc-add-support-for-gspca-vc032x
+++ a/drivers/media/video/gspca/vc032x.c
@@ -2426,6 +2426,7 @@ static const struct sd_desc sd_desc = {
 static const __devinitdata struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x046d, 0x0892), .driver_info = BRIDGE_VC0321},
 	{USB_DEVICE(0x046d, 0x0896), .driver_info = BRIDGE_VC0321},
+	{USB_DEVICE(0x046d, 0x0897), .driver_info = BRIDGE_VC0321},
 	{USB_DEVICE(0x0ac8, 0x0321), .driver_info = BRIDGE_VC0321},
 	{USB_DEVICE(0x0ac8, 0x0323), .driver_info = BRIDGE_VC0323},
 	{USB_DEVICE(0x0ac8, 0x0328), .driver_info = BRIDGE_VC0321},
_

Patches currently in -mm which might be from mail@andreas-demmer.de are

drivers-media-video-gspca-vc032xc-add-support-for-gspca-vc032x.patch

