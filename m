From: akpm@linux-foundation.org
Subject: - bcm5974-064-minor-cleanups-for-scripts-checkpatchpl.patch removed from -mm tree
Date: Mon, 08 Sep 2008 12:07:14 -0700
Message-ID: <200809081907.m88J7EuK005538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660AbYIHTH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 15:07:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, mm-commits@vger.kernel.org


The patch titled
     bcm5974-0.64: minor cleanups for scripts/checkpatch.pl
has been removed from the -mm tree.  Its filename was
     bcm5974-064-minor-cleanups-for-scripts-checkpatchpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

