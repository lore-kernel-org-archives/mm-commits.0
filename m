From: akpm@linux-foundation.org
Subject: [merged] video-s3c-fb-fix-typo-in-definition-of-vidcon1_vstatus_frontporch-value.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:43 -0800
Message-ID: <20130222203843.AD87F31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49755 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:44 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so119141qaj.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: t.figa@samsung.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: s3c-fb: fix typo in definition of VIDCON1_VSTATUS_FRONTPORCH value
has been removed from the -mm tree.  Its filename was
     video-s3c-fb-fix-typo-in-definition-of-vidcon1_vstatus_frontporch-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomasz Figa <t.figa@samsung.com>
Subject: video: s3c-fb: fix typo in definition of VIDCON1_VSTATUS_FRONTPORCH value

The correct value for VIDCON1_VSTATUS_FRONTPORCH is 3, not 0.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/samsung_fimd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/video/samsung_fimd.h~video-s3c-fb-fix-typo-in-definition-of-vidcon1_vstatus_frontporch-value include/video/samsung_fimd.h
--- a/include/video/samsung_fimd.h~video-s3c-fb-fix-typo-in-definition-of-vidcon1_vstatus_frontporch-value
+++ a/include/video/samsung_fimd.h
@@ -82,7 +82,7 @@
 #define VIDCON1_VSTATUS_VSYNC			(0x0 << 13)
 #define VIDCON1_VSTATUS_BACKPORCH		(0x1 << 13)
 #define VIDCON1_VSTATUS_ACTIVE			(0x2 << 13)
-#define VIDCON1_VSTATUS_FRONTPORCH		(0x0 << 13)
+#define VIDCON1_VSTATUS_FRONTPORCH		(0x3 << 13)
 #define VIDCON1_VCLK_MASK			(0x3 << 9)
 #define VIDCON1_VCLK_HOLD			(0x0 << 9)
 #define VIDCON1_VCLK_RUN			(0x1 << 9)
_

Patches currently in -mm which might be from t.figa@samsung.com are

origin.patch
linux-next.patch

