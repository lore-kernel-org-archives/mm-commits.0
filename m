From: akpm@linux-foundation.org
Subject: [merged] radix_tree-remove-radix_tree_indirect_to_ptr.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:01 -0800
Message-ID: <20120113203702.2B7365C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42927 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab2AMUhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:03 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25473eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix_tree: remove radix_tree_indirect_to_ptr()
has been removed from the -mm tree.  Its filename was
     radix_tree-remove-radix_tree_indirect_to_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: radix_tree: remove radix_tree_indirect_to_ptr()

It is not used anymore, remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/radix-tree.h~radix_tree-remove-radix_tree_indirect_to_ptr include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix_tree-remove-radix_tree_indirect_to_ptr
+++ a/include/linux/radix-tree.h
@@ -49,9 +49,6 @@
 #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
 #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
 
-#define radix_tree_indirect_to_ptr(ptr) \
-	radix_tree_indirect_to_ptr((void __force *)(ptr))
