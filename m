From: akpm@linux-foundation.org
Subject: [folded-dropped] lib-parserc-avoid-overflow-in-match_number-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:57:48 -0700
Message-ID: <20121004235748.77DA3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41442 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2JDX5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:57:49 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so129560vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:57:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, elder@inktank.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-parserc-avoid-overflow-in-match_number-fix
has been removed from the -mm tree.  Its filename was
     lib-parserc-avoid-overflow-in-match_number-fix.patch

This patch was dropped because it was folded into lib-parserc-avoid-overflow-in-match_number.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-parserc-avoid-overflow-in-match_number-fix

coding-style tweaks

Cc: Alex Elder <elder@inktank.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/parser.c~lib-parserc-avoid-overflow-in-match_number-fix lib/parser.c
--- a/lib/parser.c~lib-parserc-avoid-overflow-in-match_number-fix
+++ a/lib/parser.c
@@ -142,7 +142,7 @@ static int match_number(substring_t *s, 
 	val = simple_strtol(buf, &endp, base);
 	if (endp == buf)
 		ret = -EINVAL;
-	else if (val < (long) INT_MIN || val > (long) INT_MAX)
+	else if (val < (long)INT_MIN || val > (long)INT_MAX)
 		ret = -ERANGE;
 	else
 		*result = (int) val;
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

