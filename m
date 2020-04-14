From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-clarify-__gfp_memalloc-usage-update-checkpatch-fixes.patch removed from
 -mm tree
Date: Mon, 13 Apr 2020 19:13:39 -0700
Message-ID: <20200414021339.CZ1QtVx7E%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403994AbgDNCNl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 22:13:41 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-clarify-__gfp_memalloc-usage-update-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-clarify-__gfp_memalloc-usage-update-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-clarify-__gfp_memalloc-usage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-clarify-__gfp_memalloc-usage-update-checkpatch-fixes

#23: FILE: include/linux/gfp.h:116:
+ * Usage of a pre-allocated pool (e.g. mempool) should be always considered before

WARNING: Missing Signed-off-by: line by nominal patch author 'Michal Hocko <mhocko@kernel.org>'

total: 0 errors, 2 warnings, 8 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-clarify-__gfp_memalloc-usage-update.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/gfp.h~mm-clarify-__gfp_memalloc-usage-update-checkpatch-fixes
+++ a/include/linux/gfp.h
@@ -111,10 +111,10 @@ struct vm_area_struct;
  * very shortly e.g. process exiting or swapping. Users either should
  * be the MM or co-ordinating closely with the VM (e.g. swap over NFS).
  * Users of this flag have to be extremely careful to not deplete the reserve
- * completely and implement a throttling mechanism which controls the consumption
- * of the reserve based on the amount of freed memory.
- * Usage of a pre-allocated pool (e.g. mempool) should be always considered before
- * using this flag.
+ * completely and implement a throttling mechanism which controls the
+ * consumption of the reserve based on the amount of freed memory.
+ * Usage of a pre-allocated pool (e.g. mempool) should be always considered
+ * before using this flag.
  *
  * %__GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
  * This takes precedence over the %__GFP_MEMALLOC flag if both are set.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
