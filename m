From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-max77686-add-maxim-77686-driver-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:26:37 -0800
Message-ID: <20130221232638.218155A422F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:55240 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3BUX0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:26:39 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so11258yen.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:26:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jonghwa3.lee@samsung.com, kyungmin.park@samsung.com, myungjoo.ham@samsung.com, woong.byun@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-max77686-add-maxim-77686-driver-fix
has been removed from the -mm tree.  Its filename was
     rtc-max77686-add-maxim-77686-driver-fix.patch

This patch was dropped because it was folded into rtc-max77686-add-maxim-77686-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-max77686-add-maxim-77686-driver-fix

remove inline, __devinit annotations

Cc: Chiwoong Byun <woong.byun@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Myugnjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-add-maxim-77686-driver-fix drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-add-maxim-77686-driver-fix
+++ a/drivers/rtc/rtc-max77686.c
@@ -129,7 +129,7 @@ static int max77686_rtc_tm_to_data(struc
 	return 0;
 }
 
-static inline int max77686_rtc_update(struct max77686_rtc_info *info,
+static int max77686_rtc_update(struct max77686_rtc_info *info,
 	enum MAX77686_RTC_OP op)
 {
 	int ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
ocfs2-remove-kfree-redundant-null-checks.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
rtc-max77686-add-maxim-77686-driver.patch
rtc-max77686-add-missing-variable-initialization-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch

