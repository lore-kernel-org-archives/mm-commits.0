From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:13 -0700
Message-ID: <20121009181213.AB8F71E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37510 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:14 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so662400vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: Update try_to_compact_pages()kerneldoc comment
has been removed from the -mm tree.  Its filename was
     mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: Update try_to_compact_pages()kerneldoc comment

Parameters were added without documentation, tut tut.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/compaction.c~mm-compaction-update-try_to_compact_pageskerneldoc-comment mm/compaction.c
--- a/mm/compaction.c~mm-compaction-update-try_to_compact_pageskerneldoc-comment
+++ a/mm/compaction.c
@@ -926,6 +926,8 @@ int sysctl_extfrag_threshold = 500;
  * @gfp_mask: The GFP mask of the current allocation
  * @nodemask: The allowed nodes to allocate from
  * @sync: Whether migration is synchronous or not
+ * @contended: Return value that is true if compaction was aborted due to lock contention
+ * @page: Optionally capture a free page of the requested order during compaction
  *
  * This is the main entry point for direct page compaction.
  */
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

