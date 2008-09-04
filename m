From: akpm@linux-foundation.org
Subject: + bcm5974-064-minor-cleanups-for-scripts-checkpatchpl.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:12:59 -0700
Message-ID: <200809042112.m84LCxUV031361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbYIDVNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:13:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se


The patch titled
     bcm5974-0.64: minor cleanups for scripts/checkpatch.pl
has been added to the -mm tree.  Its filename is
     bcm5974-064-minor-cleanups-for-scripts-checkpatchpl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bcm5974-0.64: minor cleanups for scripts/checkpatch.pl
From: Henrik Rydberg <rydberg@euromail.se>

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/bcm5974.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/mouse/bcm5974.c~bcm5974-064-minor-cleanups-for-scripts-checkpatchpl drivers/input/mouse/bcm5974.c
--- a/drivers/input/mouse/bcm5974.c~bcm5974-064-minor-cleanups-for-scripts-checkpatchpl
+++ a/drivers/input/mouse/bcm5974.c
@@ -63,7 +63,7 @@
 }
 
 /* table of devices that work with this driver */
-static const struct usb_device_id bcm5974_table [] = {
+static const struct usb_device_id bcm5974_table[] = {
 	/* MacbookAir1.1 */
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING_ISO),
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
linux-next.patch
bcm5974-064-minor-cleanups-for-scripts-checkpatchpl.patch
bcm5974-063-finger-counting-improved.patch
bcm5974-063-btn_touch-event-added-for-mousedev.patch

