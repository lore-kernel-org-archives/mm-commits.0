From: akpm@linux-foundation.org
Subject: + page-types-add-gpl-note.patch added to -mm tree
Date: Tue, 29 Sep 2009 14:46:12 -0700
Message-ID: <200909292146.n8TLkCX5012849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbZI2VqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:46:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@firstfloor.org


The patch titled
     page-types: add GPL note
has been added to the -mm tree.  Its filename is
     page-types-add-gpl-note.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: add GPL note
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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

linux-next.patch
pagemap-export-kpf_hwpoison.patch
pagemap-document-kpf_ksm-and-show-it-in-page-types.patch
page-types-add-gpl-note.patch
page-types-introduce-checked_open.patch
page-types-make-standalone-pagemap-kpageflags-read-routines.patch
page-types-make-voffset-local-variables.patch
page-types-introduce-kpageflags_flags.patch
page-types-add-hwpoison-unpoison-feature.patch
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

