From: akpm@linux-foundation.org
Subject: + drivers-video-aty-radeon_basec-fix-typo-in-comment.patch added to -mm tree
Date: Thu, 09 Apr 2009 12:46:52 -0700
Message-ID: <200904091946.n39JkqMU024360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759132AbZDITsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 15:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulepanter@users.sourceforge.net


The patch titled
     drivers/video/aty/radeon_base.c: fix typo in comment
has been added to the -mm tree.  Its filename is
     drivers-video-aty-radeon_basec-fix-typo-in-comment.patch

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

drivers-video-aty-radeon_basec-fix-typo-in-comment.patch

