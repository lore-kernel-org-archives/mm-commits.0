From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch removed
 from -mm tree
Date: Wed, 06 Aug 2014 13:28:36 -0700
Message-ID: <53e28ff4.s6gFM/VA2eBu2S9B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:55739 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaHFU2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 16:28:37 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so790507pde.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 13:28:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch

This patch was dropped because it was folded into ocfs2-free-inode-when-i_count-becomes-zero.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes

ERROR: trailing whitespace
#41: FILE: fs/ocfs2/inode.c:1197:
+^Ireturn 1; $

total: 1 errors, 0 warnings, 18 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/ocfs2-free-inode-when-i_count-becomes-zero.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Xue jiufei <xuejiufei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/inode.c~ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes
+++ a/fs/ocfs2/inode.c
@@ -1194,7 +1194,7 @@ int ocfs2_drop_inode(struct inode *inode
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
 				inode->i_nlink, oi->ip_flags);
-	return 1; 
+	return 1;
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions-checkpatch-fixes.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch

