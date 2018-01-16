From: akpm@linux-foundation.org
Subject: + mm-compaction-fix-the-comment-for-try_to_compact_pages.patch
 added to -mm tree
Date: Tue, 16 Jan 2018 14:21:33 -0800
Message-ID: <5a5e7aed.9RE3SMvXAtR4Ojuu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeAPWVe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jan 2018 17:21:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linux.alibaba.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: fix comment for try_to_compact_pages()
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-the-comment-for-try_to_compact_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-fix-the-comment-for-try_to_compact_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-fix-the-comment-for-try_to_compact_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/compaction.c: fix comment for try_to_compact_pages()

"mode" argument is not used by try_to_compact_pages() and sub functions
anymore, it has been replaced by "prio".  Fix the comment to explain the
use of "prio" argument.

Link: http://lkml.kernel.org/r/1515801336-20611-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -1736,7 +1736,7 @@ int sysctl_extfrag_threshold = 500;
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

mm-compaction-fix-the-comment-for-try_to_compact_pages.patch

