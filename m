From: akpm@linux-foundation.org
Subject: + video-s3c-fb-fix-typo-in-definition-of-vidcon1_vstatus_frontporch-value.patch added to -mm tree
Date: Tue, 19 Feb 2013 14:39:47 -0800
Message-ID: <20130219223948.308FE5A43B3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:53070 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211Ab3BSWjv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 17:39:51 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so731728ves.3
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 14:39:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: t.figa@samsung.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, kyungmin.park@samsung.com


The patch titled
     Subject: video: s3c-fb: fix typo in definition of VIDCON1_VSTATUS_FRONTPORCH value
has been added to the -mm tree.  Its filename is
     video-s3c-fb-fix-typo-in-definition-of-vidcon1_vstatus_frontporch-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
video-s3c-fb-use-arch_-dependancy.patch
video-s3c-fb-remove-duplicated-s3c_fb_max_win.patch
video-s3c-fb-remove-unnecessary-brackets.patch
video-s3c-fb-add-the-bit-definitions-for-csc-eq709-and-eq601.patch
video-s3c-fb-fix-typo-in-definition-of-vidcon1_vstatus_frontporch-value.patch

