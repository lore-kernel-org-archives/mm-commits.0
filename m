From: akpm@linux-foundation.org
Subject: [folded-merged] bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 16:08:34 -0800
Message-ID: <20130222000835.543625A403C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:33391 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3BVAIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 19:08:36 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so14956yen.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 16:08:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.santos@pobox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bugh-prevent-double-evaulation-of-in-build_bug_on-fix
has been removed from the -mm tree.  Its filename was
     bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch

This patch was dropped because it was folded into bugh-prevent-double-evaulation-of-in-build_bug_on.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bugh-prevent-double-evaulation-of-in-build_bug_on-fix

tweak code layout

Cc: Daniel Santos <daniel.santos@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bug.h~bugh-prevent-double-evaulation-of-in-build_bug_on-fix include/linux/bug.h
--- a/include/linux/bug.h~bugh-prevent-double-evaulation-of-in-build_bug_on-fix
+++ a/include/linux/bug.h
@@ -62,7 +62,7 @@ extern int __build_bug_on_failed;
 		bool __cond = !!(condition);			\
 		((void)sizeof(char[1 - 2 * __cond]));		\
 		if (__cond) __build_bug_on_failed = 1;		\
-	} while(0)
+	} while (0)
 #endif
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
ocfs2-remove-kfree-redundant-null-checks.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
rtc-max77686-add-maxim-77686-driver.patch
rtc-pcf8523-add-low-battery-voltage-support.patch
rtc-add-rtc-driver-for-tps80031-tps80032.patch
rtc-add-support-for-spi-rtc-rx4581.patch

