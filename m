From: akpm@linux-foundation.org
Subject: [merged] mm-adjust-final-endif-position-in-mm-internalh.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:24 -0700
Message-ID: <20121009180725.1EABE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:45893 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:27 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so285461wib.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: adjust final #endif position in mm/internal.h
has been removed from the -mm tree.  Its filename was
     mm-adjust-final-endif-position-in-mm-internalh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
prio_tree-remove-fix.patch

