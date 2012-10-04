From: akpm@linux-foundation.org
Subject: [folded-dropped] backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:56:28 -0700
Message-ID: <20121004235629.9208220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:46622 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JDX4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:56:32 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so78122lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:56:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-platform-lcd-add-support-for-device-tree-based-probe-fix
has been removed from the -mm tree.  Its filename was
     backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch

This patch was dropped because it was folded into backlight-platform-lcd-add-support-for-device-tree-based-probe.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-platform-lcd-add-support-for-device-tree-based-probe-fix

include of.h

Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-platform-lcd-add-support-for-device-tree-based-probe-fix drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-platform-lcd-add-support-for-device-tree-based-probe-fix
+++ a/drivers/video/backlight/platform_lcd.c
@@ -16,6 +16,7 @@
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/lcd.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 
 #include <video/platform_lcd.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

