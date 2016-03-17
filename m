From: akpm@linux-foundation.org
Subject: [folded-merged] radix-tree-test-harness-fix.patch removed from
 -mm tree
Date: Thu, 17 Mar 2016 14:00:14 -0700
Message-ID: <56eb1ade.UJ4/0F79VYScwx1q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbcCQVAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 17:00:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree tests: fix compilation
has been removed from the -mm tree.  Its filename was
     radix-tree-test-harness-fix.patch

This patch was dropped because it was folded into radix-tree-test-harness.patch

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: radix-tree tests: fix compilation

Couple GFP flags and empty header linux/init.h

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/gfp.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN tools/testing/radix-tree/linux/gfp.h~radix-tree-test-harness-fix tools/testing/radix-tree/linux/gfp.h
--- a/tools/testing/radix-tree/linux/gfp.h~radix-tree-test-harness-fix
+++ a/tools/testing/radix-tree/linux/gfp.h
@@ -4,5 +4,7 @@
 #define __GFP_BITS_SHIFT 22
 #define __GFP_BITS_MASK ((gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 #define __GFP_WAIT 1
+#define __GFP_ACCOUNT 0
+#define __GFP_NOWARN 0
 
 #endif
_

Patches currently in -mm which might be from koct9i@gmail.com are

tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering.patch
radix-tree-test-harness.patch
radix-treeshmem-introduce-radix_tree_iter_next-fix.patch
radix-tree-tests-add-regression3-test.patch
radix-tree-tests-add-test-for-radix_tree_iter_next.patch

