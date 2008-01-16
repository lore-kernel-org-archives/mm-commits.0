From: akpm@linux-foundation.org
Subject: - s3c2410fb-fix-incorrect-argument-type-in-resume-function.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:38:36 -0800
Message-ID: <200801160138.m0G1caPV013921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119AbYAPBim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:38:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: fix incorrect argument type in resume function
has been removed from the -mm tree.  Its filename was
     s3c2410fb-fix-incorrect-argument-type-in-resume-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c2410fb: fix incorrect argument type in resume function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix wrong pointer type passed into the s3c2410fb_init_registers() function.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-fix-incorrect-argument-type-in-resume-function drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-fix-incorrect-argument-type-in-resume-function
+++ a/drivers/video/s3c2410fb.c
@@ -1026,7 +1026,7 @@ static int s3c2410fb_resume(struct platf
 	clk_enable(info->clk);
 	msleep(1);
 
-	s3c2410fb_init_registers(info);
+	s3c2410fb_init_registers(fbinfo);
 
 	return 0;
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
git-scsi-misc.patch
drivers-video-pm3fbc-section-fix.patch
