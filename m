From: akpm@linux-foundation.org
Subject: + mm-adjust-final-endif-position-in-mm-internalh.patch added to -mm tree
Date: Fri, 24 Aug 2012 15:31:00 -0700
Message-ID: <20120824223100.928E3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46610 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab2HXWbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 18:31:01 -0400
Received: by vcqp1 with SMTP id p1so339072vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 15:31:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com


The patch titled
     Subject: mm: adjust final #endif position in mm/internal.h
has been added to the -mm tree.  Its filename is
     mm-adjust-final-endif-position-in-mm-internalh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: adjust final #endif position in mm/internal.h

Make sure the #endif that terminates the standard #ifndef / #define /
#endif construct gets labeled, and gets positioned at the end of the file
as is normally the case.

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/internal.h~mm-adjust-final-endif-position-in-mm-internalh mm/internal.h
--- a/mm/internal.h~mm-adjust-final-endif-position-in-mm-internalh
+++ a/mm/internal.h
@@ -341,7 +341,6 @@ static inline void mminit_validate_memmo
 #define ZONE_RECLAIM_FULL	-1
 #define ZONE_RECLAIM_SOME	0
 #define ZONE_RECLAIM_SUCCESS	1
-#endif
 
 extern int hwpoison_filter(struct page *p);
 
@@ -357,3 +356,5 @@ extern unsigned long vm_mmap_pgoff(struc
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
+
+#endif	/* __MM_INTERNAL_H */
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-adjust-final-endif-position-in-mm-internalh.patch
ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-empty-nodes-have-no-color-fix.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch
rbtree-performance-and-correctness-test.patch
rbtree-performance-and-correctness-test-fix.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch

