From: akpm@linux-foundation.org
Subject: [folded-merged] bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 21 Feb 2013 16:09:44 -0800
Message-ID: <20130222000945.5FB0231C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:35142 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3BVAJq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 19:09:46 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so15102qen.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 16:09:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.santos@pobox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch

This patch was dropped because it was folded into bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes

WARNING: please, no space before tabs
#56: FILE: include/linux/bug.h:45:
+ * ^I^I      error message.$

total: 0 errors, 1 warnings, 88 lines checked

./patches/bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Daniel Santos <daniel.santos@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bug.h~bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes include/linux/bug.h
--- a/include/linux/bug.h~bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes
+++ a/include/linux/bug.h
@@ -42,7 +42,7 @@ struct pt_regs;
 
 /**
  * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
- * 		      error message.
+ *		      error message.
  * @condition: the condition which the compiler should know is false.
  *
  * See BUILD_BUG_ON for description.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
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

