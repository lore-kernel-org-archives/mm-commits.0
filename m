From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch added to -mm
 tree
Date: Tue, 14 Jan 2020 16:22:26 -0800
Message-ID: <20200115002226.CtDm17CwK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728774AbgAOAW1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix

renumber the bits for neatness

Cc: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix
+++ a/mm/vmscan.c
@@ -4118,8 +4118,8 @@ module_init(kswapd_init)
  */
 int node_reclaim_mode __read_mostly;
 
-#define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
-#define RECLAIM_UNMAP (1<<2)	/* Unmap pages during reclaim */
+#define RECLAIM_WRITE (1<<0)	/* Writeout pages during reclaim */
+#define RECLAIM_UNMAP (1<<1)	/* Unmap pages during reclaim */
 
 /*
  * Priority for NODE_RECLAIM. This determines the fraction of pages
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
