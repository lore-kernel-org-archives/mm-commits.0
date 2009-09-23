From: akpm@linux-foundation.org
Subject: [merged] omapfb-hwa742-fix-pointer-to-be-const.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:00:58 -0700
Message-ID: <200909232000.n8NK0wLP014223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbZIWUKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@nokia.com, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     omapfb: HWA742: fix pointer to be const
has been removed from the -mm tree.  Its filename was
     omapfb-hwa742-fix-pointer-to-be-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omapfb: HWA742: fix pointer to be const
From: Imre Deak <imre.deak@nokia.com>

Fixes the following:
warning: assignment discards qualifiers from pointer target type

Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/hwa742.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/omap/hwa742.c~omapfb-hwa742-fix-pointer-to-be-const drivers/video/omap/hwa742.c
--- a/drivers/video/omap/hwa742.c~omapfb-hwa742-fix-pointer-to-be-const
+++ a/drivers/video/omap/hwa742.c
@@ -131,7 +131,7 @@ struct {
 
 	struct omapfb_device	*fbdev;
 	struct lcd_ctrl_extif	*extif;
-	struct lcd_ctrl		*int_ctrl;
+	const struct lcd_ctrl	*int_ctrl;
 
 	struct clk		*sys_ck;
 } hwa742;
_

Patches currently in -mm which might be from imre.deak@nokia.com are

origin.patch

