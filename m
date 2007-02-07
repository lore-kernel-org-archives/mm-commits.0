From: akpm@linux-foundation.org
Subject: - drivers-media-video-cafe_ccicc-fix-warning.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:51:29 -0800
Message-ID: <200702071951.l17JpThE025160@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33510 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161109AbXBGTvj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:51:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/cafe_ccic.c fix warning
has been removed from the -mm tree.  Its filename was
     drivers-media-video-cafe_ccicc-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/media/video/cafe_ccic.c fix warning
From: corbet@lwn.net (Jonathan Corbet)

Quiet a spurious gcc warning.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cafe_ccic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/cafe_ccic.c~drivers-media-video-cafe_ccicc-fix-warning drivers/media/video/cafe_ccic.c
--- a/drivers/media/video/cafe_ccic.c~drivers-media-video-cafe_ccicc-fix-warning
+++ a/drivers/media/video/cafe_ccic.c
@@ -1194,7 +1194,7 @@ static int cafe_vidioc_reqbufs(struct fi
 		struct v4l2_requestbuffers *req)
 {
 	struct cafe_camera *cam = filp->private_data;
-	int ret;
+	int ret = 0;  /* Silence warning */
 
 	/*
 	 * Make sure it's something we can do.  User pointers could be
_

Patches currently in -mm which might be from corbet@lwn.net are

git-dvb.patch
