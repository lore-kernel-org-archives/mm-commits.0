From: akpm@linux-foundation.org
Subject: + fbmon-remove-unnecessary-local-variable.patch added to -mm tree
Date: Thu, 29 Nov 2007 12:32:00 -0800
Message-ID: <200711292032.lATKW05j006005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756598AbXK2UcI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 15:32:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@bitwigglers.org, adaplas@pol.net


The patch titled
     fbmon: remove unnecessary local variable
has been added to the -mm tree.  Its filename is
     fbmon-remove-unnecessary-local-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbmon: remove unnecessary local variable
From: Andre Haupt <andre@bitwigglers.org>

This fixes a sparse warning about symbol 'i' shadowing an earlier one.

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbmon.c~fbmon-remove-unnecessary-local-variable drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~fbmon-remove-unnecessary-local-variable
+++ a/drivers/video/fbmon.c
@@ -686,7 +686,7 @@ static int fb_get_monitor_limits(unsigne
 	/* estimate monitor limits based on modes supported */
 	if (retval) {
 		struct fb_videomode *modes, *mode;
-		int num_modes, i, hz, hscan, pixclock;
+		int num_modes, hz, hscan, pixclock;
 		int vtotal, htotal;
 
 		modes = fb_create_modedb(edid, &num_modes);
_

Patches currently in -mm which might be from andre@bitwigglers.org are

git-arm.patch
sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars.patch
fbmon-remove-unnecessary-local-variable.patch
fbmon-cleanup-trailing-whitespaces.patch
