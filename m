From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Wed, 15 Jan 2020 17:29:21 -0800
Message-ID: <20200116012921.pNPXOkRN4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgAPB3W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Jan 2020 20:29:22 -0500
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

 arch/parisc/kernel/drivers.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/parisc/kernel/drivers.c~linux-next-git-rejects
+++ a/arch/parisc/kernel/drivers.c
@@ -889,11 +889,7 @@ static void print_parisc_device(struct p
 	static int count;
 
 	print_pa_hwpath(dev, hw_path);
-<<<<<<< HEAD
-	pr_info("%d. %s at %pap [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
-=======
 	pr_info("%d. %s at %pa[p] [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
->>>>>>> linux-next/akpm-base
 		++count, dev->name, &(dev->hpa.start), hw_path, dev->id.hw_type,
 		dev->id.hversion_rev, dev->id.hversion, dev->id.sversion);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch
mm-mempolicy-skip-walking-hugetlb-vma-if-mpol_mf_strict-is-specified-alone-checkpatch-fixes.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-fix.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
