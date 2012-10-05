From: akpm@linux-foundation.org
Subject: [folded-dropped] fat-simplify-writeback_inode-checkpatch-fixes-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:01:30 -0700
Message-ID: <20121005000131.5AF7B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:46524 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2JEABe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:01:34 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so75504eek.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:01:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp, linkinjeon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat-simplify-writeback_inode-checkpatch-fixes-fix
has been removed from the -mm tree.  Its filename was
     fat-simplify-writeback_inode-checkpatch-fixes-fix.patch

This patch was dropped because it was folded into fat-simplify-writeback_inode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fat-simplify-writeback_inode-checkpatch-fixes-fix

Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-simplify-writeback_inode-checkpatch-fixes-fix fs/fat/inode.c
--- a/fs/fat/inode.c~fat-simplify-writeback_inode-checkpatch-fixes-fix
+++ a/fs/fat/inode.c
@@ -1470,7 +1470,7 @@ static int writeback_inode(struct inode 
 	*/
 	ret = sync_inode_metadata(inode, 0);
 	if (!ret)
-		= filemap_fdatawrite(inode->i_mapping);
+		ret = filemap_fdatawrite(inode->i_mapping);
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
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

