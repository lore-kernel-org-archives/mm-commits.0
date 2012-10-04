From: akpm@linux-foundation.org
Subject: [folded-dropped] rtc-add-dallas-ds2404-driver-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:58:41 -0700
Message-ID: <20121004235842.759015C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:58172 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2JDX6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:58:44 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so78159lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:58:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, svens@stackframe.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-dallas-ds2404-driver-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-dallas-ds2404-driver-fix.patch

This patch was dropped because it was folded into rtc-add-dallas-ds2404-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-add-dallas-ds2404-driver-fix

drivers/rtc/rtc-ds2404.c:23:1: warning: "DEBUG" redefined <command-line>:
warning: this is the location of the previous definition

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds2404.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-ds2404.c~rtc-add-dallas-ds2404-driver-fix drivers/rtc/rtc-ds2404.c
--- a/drivers/rtc/rtc-ds2404.c~rtc-add-dallas-ds2404-driver-fix
+++ a/drivers/rtc/rtc-ds2404.c
@@ -20,8 +20,6 @@
 
 #include <linux/io.h>
 
-#define DEBUG
-
 #define DS2404_STATUS_REG 0x200
 #define DS2404_CONTROL_REG 0x201
 #define DS2404_RTC_REG 0x202
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
idr-rename-max_level-to-max_idr_level.patch
lib-parserc-avoid-overflow-in-match_number.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock.patch
rtc-add-dallas-ds2404-driver.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

