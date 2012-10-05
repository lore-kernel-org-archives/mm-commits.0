From: akpm@linux-foundation.org
Subject: [folded-dropped] coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:02:52 -0700
Message-ID: <20121005000253.8A3CC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50193 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2JEAC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:02:56 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so78253lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:02:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch

This patch was dropped because it was folded into coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes

ERROR: space required before the open parenthesis '('
#35: FILE: fs/proc/base.c:1401:
+	if(dumpable == SUID_DUMPABLE_ENABLED)

total: 1 errors, 0 warnings, 16 lines checked

./patches/coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/internal.h~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes fs/proc/internal.h
--- a/fs/proc/internal.h~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes
+++ a/fs/proc/internal.h
@@ -103,7 +103,7 @@ static inline int task_dumpable(struct t
 	if (mm)
 		dumpable = get_dumpable(mm);
 	task_unlock(task);
-	if(dumpable == SUID_DUMPABLE_ENABLED)
+	if (dumpable == SUID_DUMPABLE_ENABLED)
 		return 1;
 	return 0;
 }
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
fat-simplify-writeback_inode.patch
coredump-make-core-dump-functionality-optional.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

