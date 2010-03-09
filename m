From: akpm@linux-foundation.org
Subject: [merged] mm-add-comment-about-deprecation-of-__gfp_nofail.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:47 -0800
Message-ID: <201003091904.o29J4lXp031065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953Ab0CITWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: add comment about deprecation of __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     mm-add-comment-about-deprecation-of-__gfp_nofail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add comment about deprecation of __GFP_NOFAIL
From: David Rientjes <rientjes@google.com>

__GFP_NOFAIL was deprecated in dab48dab, so add a comment that no new
users should be added.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-add-comment-about-deprecation-of-__gfp_nofail include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-comment-about-deprecation-of-__gfp_nofail
+++ a/include/linux/gfp.h
@@ -30,7 +30,8 @@ struct vm_area_struct;
  * _might_ fail.  This depends upon the particular VM implementation.
  *
  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- * cannot handle allocation failures.
+ * cannot handle allocation failures.  This modifier is deprecated and no new
+ * users should be added.
  *
  * __GFP_NORETRY: The VM implementation must not retry indefinitely.
  *
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
memcg-handle-panic_on_oom=always-case-v2.patch
memcg-fix-oom-kill-behavior-v3.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
nodemask-fix-the-declaration-of-nodemask_alloc.patch
cpuset-alloc-nodemask_t-at-heap-not-stack.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

