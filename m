From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:29:11 -0800
Message-ID: <20130221232911.746EC31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34754 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3BUX3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:29:12 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so11154ggi.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:29:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, devendra.aaru@gmail.com, ldewangan@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch

This patch was dropped because it was folded into rtc-add-rtc-driver-for-tps80031-tps80032.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix

remove obsolete __devinit/__devexit

Cc: Devendra Naga <devendra.aaru@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps80031.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-tps80031.c~rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix drivers/rtc/rtc-tps80031.c
--- a/drivers/rtc/rtc-tps80031.c~rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix
+++ a/drivers/rtc/rtc-tps80031.c
@@ -233,7 +233,7 @@ static const struct rtc_class_ops tps800
 	.alarm_irq_enable = tps80031_rtc_alarm_irq_enable,
 };
 
-static int __devinit tps80031_rtc_probe(struct platform_device *pdev)
+static int tps80031_rtc_probe(struct platform_device *pdev)
 {
 	struct tps80031_rtc *rtc;
 	struct rtc_time tm;
@@ -298,7 +298,7 @@ static int __devinit tps80031_rtc_probe(
 	return 0;
 }
 
-static int __devexit tps80031_rtc_remove(struct platform_device *pdev)
+static int tps80031_rtc_remove(struct platform_device *pdev)
 {
 	struct tps80031_rtc *rtc = platform_get_drvdata(pdev);
 
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
rtc-pcf8523-add-low-battery-voltage-support.patch
rtc-add-rtc-driver-for-tps80031-tps80032.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch

