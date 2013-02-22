From: akpm@linux-foundation.org
Subject: [merged] video-s3c-fb-remove-duplicated-s3c_fb_max_win.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:34 -0800
Message-ID: <20130222203834.ABE975A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43471 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:35 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so119227qaj.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, FlorianSchandinat@gmx.de, kyungmin.park@samsung.com, t.figa@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: s3c-fb: remove duplicated S3C_FB_MAX_WIN
has been removed from the -mm tree.  Its filename was
     video-s3c-fb-remove-duplicated-s3c_fb_max_win.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: video: s3c-fb: remove duplicated S3C_FB_MAX_WIN

S3C_FB_MAX_WIN is already defined in 'plat-samsung/include/plat/fb.h'. 
So, this definition in 'include/video/samsung_fimd.h' should be removed to
avoid the duplication.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/samsung_fimd.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/video/samsung_fimd.h~video-s3c-fb-remove-duplicated-s3c_fb_max_win include/video/samsung_fimd.h
--- a/include/video/samsung_fimd.h~video-s3c-fb-remove-duplicated-s3c_fb_max_win
+++ a/include/video/samsung_fimd.h
@@ -438,8 +438,6 @@
 #define BLENDCON_NEW_8BIT_ALPHA_VALUE		(1 << 0)
 #define BLENDCON_NEW_4BIT_ALPHA_VALUE		(0 << 0)
 
-#define S3C_FB_MAX_WIN (5)  /* number of hardware windows available. */
