From: akpm@linux-foundation.org
Subject: [folded-dropped] fat-simplify-writeback_inode-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:01:26 -0700
Message-ID: <20121005000126.EF7BB5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59646 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2JEAB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:01:29 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so75993wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:01:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp, linkinjeon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat-simplify-writeback_inode-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fat-simplify-writeback_inode-checkpatch-fixes.patch

This patch was dropped because it was folded into fat-simplify-writeback_inode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fat-simplify-writeback_inode-checkpatch-fixes

WARNING: suspect code indent for conditional statements (8, 15)
#34: FILE: fs/fat/inode.c:1466:
 	if (!ret)
+	       ret = filemap_fdatawrite(inode->i_mapping);

total: 0 errors, 1 warnings, 23 lines checked

./patches/fat-simplify-writeback_inode.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-simplify-writeback_inode-checkpatch-fixes fs/fat/inode.c
--- a/fs/fat/inode.c~fat-simplify-writeback_inode-checkpatch-fixes
+++ a/fs/fat/inode.c
@@ -1470,7 +1470,7 @@ static int writeback_inode(struct inode 
 	*/
 	ret = sync_inode_metadata(inode, 0);
 	if (!ret)
-	       ret = filemap_fdatawrite(inode->i_mapping);
+		= filemap_fdatawrite(inode->i_mapping);
 	return ret;
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
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

