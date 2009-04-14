From: akpm@linux-foundation.org
Subject: [merged] drivers-video-aty-radeon_basec-fix-typo-in-comment.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:07 -0700
Message-ID: <200904141949.n3EJn7PN019406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393AbZDNTvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:51:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulepanter@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/aty/radeon_base.c: fix typo in comment
has been removed from the -mm tree.  Its filename was
     drivers-video-aty-radeon_basec-fix-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/aty/radeon_base.c: fix typo in comment
From: Paul Menzel <paulepanter@users.sourceforge.net>

Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/aty/radeon_base.c~drivers-video-aty-radeon_basec-fix-typo-in-comment drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~drivers-video-aty-radeon_basec-fix-typo-in-comment
+++ a/drivers/video/aty/radeon_base.c
@@ -698,8 +698,8 @@ static void __devinit radeon_get_pllinfo
 found:
 	/*
 	 * Some methods fail to retrieve SCLK and MCLK values, we apply default
-	 * settings in this case (200Mhz). If that really happne often, we could
-	 * fetch from registers instead...
+	 * settings in this case (200Mhz). If that really happens often, we
+	 * could fetch from registers instead...
 	 */
 	if (rinfo->pll.mclk == 0)
 		rinfo->pll.mclk = 20000;
_

Patches currently in -mm which might be from paulepanter@users.sourceforge.net are

origin.patch

