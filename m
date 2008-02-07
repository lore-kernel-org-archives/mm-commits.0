From: akpm@linux-foundation.org
Subject: - fbmon-remove-unnecessary-local-variable.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:12 -0800
Message-ID: <200802070027.m170Rr9m007090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935041AbYBGAoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbmon: remove unnecessary local variable
has been removed from the -mm tree.  Its filename was
     fbmon-remove-unnecessary-local-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-input.patch
