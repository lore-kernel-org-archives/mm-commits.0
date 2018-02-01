From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-fix-the-comment-for-try_to_compact_pages.patch removed from
 -mm tree
Date: Thu, 01 Feb 2018 11:34:19 -0800
Message-ID: <20180201193419.2V-mpj5uU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754648AbeBATeZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, vbabka@suse.cz, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/compaction.c: fix comment for try_to_compact_pages()
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-the-comment-for-try_to_compact_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/compaction.c: fix comment for try_to_compact_pages()

"mode" argument is not used by try_to_compact_pages() and sub functions
anymore, it has been replaced by "prio".  Fix the comment to explain the
use of "prio" argument.

Link: http://lkml.kernel.org/r/1515801336-20611-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-fix-the-comment-for-try_to_compact_pages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-the-comment-for-try_to_compact_pages
+++ a/mm/compaction.c
@@ -1738,7 +1738,7 @@ int sysctl_extfrag_threshold = 500;
  * @order: The order of the current allocation
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
- * @mode: The migration mode for async, sync light, or sync migration
+ * @prio: Determines how hard direct compaction should try to succeed
  *
  * This is the main entry point for direct page compaction.
  */
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are


