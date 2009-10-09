From: akpm@linux-foundation.org
Subject: [merged] page-types-add-gpl-note.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:05 -0700
Message-ID: <200910092205.n99M55ll020660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934566AbZJIWFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     page-types: add GPL note
has been removed from the -mm tree.  Its filename was
     page-types-add-gpl-note.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: add GPL note
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/page-types.c~page-types-add-gpl-note Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-add-gpl-note
+++ a/Documentation/vm/page-types.c
@@ -2,7 +2,10 @@
  * page-types: Tool for querying page flags
  *
  * Copyright (C) 2009 Intel corporation
- * Copyright (C) 2009 Wu Fengguang <fengguang.wu@intel.com>
+ *
+ * Authors: Wu Fengguang <fengguang.wu@intel.com>
+ *
+ * Released under the General Public License (GPL).
  */
 
 #define _LARGEFILE64_SOURCE
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

