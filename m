From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Wed, 19 Jul 2017 13:10:17 -0700
Message-ID: <20170719201017.cVdFCM_mz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbdGSUKS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 16:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/verbs.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/infiniband/core/verbs.c~linux-next-git-rejects drivers/infiniband/core/verbs.c
--- a/drivers/infiniband/core/verbs.c~linux-next-git-rejects
+++ a/drivers/infiniband/core/verbs.c
@@ -1298,11 +1298,7 @@ int ib_modify_qp_with_udata(struct ib_qp
 		if (ret)
 			return ret;
 	}
-<<<<<<< HEAD
-	return ib_security_modify_qp(qp, attr, attr_mask, udata);
-=======
 	return ib_security_modify_qp(qp->real_qp, attr, attr_mask, udata);
->>>>>>> linux-next/akpm-base
 }
 EXPORT_SYMBOL(ib_modify_qp_with_udata);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

