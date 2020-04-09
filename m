From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete]
 mm-clarify-__gfp_memalloc-usage-checkpatch-fixes.patch removed from -mm
 tree
Date: Wed, 08 Apr 2020 18:24:44 -0700
Message-ID: <20200409012444.n8iR0EHK-%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgDIBYp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 21:24:45 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-clarify-__gfp_memalloc-usage-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-clarify-__gfp_memalloc-usage-checkpatch-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-clarify-__gfp_memalloc-usage-checkpatch-fixes

WARNING: line over 80 characters
#32: FILE: include/linux/gfp.h:114:
+ * completely and implement a throttling mechanism which controls the consumption

total: 0 errors, 1 warnings, 9 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-clarify-__gfp_memalloc-usage.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/gfp.h~mm-clarify-__gfp_memalloc-usage-checkpatch-fixes
+++ a/include/linux/gfp.h
@@ -111,8 +111,8 @@ struct vm_area_struct;
  * very shortly e.g. process exiting or swapping. Users either should
  * be the MM or co-ordinating closely with the VM (e.g. swap over NFS).
  * Users of this flag have to be extremely careful to not deplete the reserve
- * completely and implement a throttling mechanism which controls the consumption
- * of the reserve based on the amount of freed memory.
+ * completely and implement a throttling mechanism which controls the
+ * consumption of the reserve based on the amount of freed memory.
  *
  * %__GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
  * This takes precedence over the %__GFP_MEMALLOC flag if both are set.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
