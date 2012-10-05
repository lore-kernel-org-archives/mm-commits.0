From: akpm@linux-foundation.org
Subject: [folded-dropped] fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:00:47 -0700
Message-ID: <20121005000048.18E1C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:55486 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2JEAAs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:00:48 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so129686ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:00:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix
has been removed from the -mm tree.  Its filename was
     fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch

This patch was dropped because it was folded into fs-fat-fix-all-other-checkpatch-issues-in-dirc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix

Cc: Cruz Julian Bishop <cruzjbishop@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/fat/dir.c~fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix fs/fat/dir.c
--- a/fs/fat/dir.c~fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix
+++ a/fs/fat/dir.c
@@ -224,7 +224,6 @@ fat_short2lower_uni(struct nls_table *t,
 			nc = *c;
 
 		charlen = t->char2uni(&nc, 1, uni);
-
 		if (charlen < 0) {
 			*uni = 0x003f;	/* a question mark */
 			charlen = 1;
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
fs-fat-fix-all-other-checkpatch-issues-in-dirc.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

