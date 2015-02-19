From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-fixup.patch removed from -mm tree
Date: Thu, 19 Feb 2015 10:49:15 -0800
Message-ID: <54e6302b.kkqLDEgsCyIQeuEv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbbBSStQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Feb 2015 13:49:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-fixup
has been removed from the -mm tree.  Its filename was
     linux-next-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-fixup

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/mtd/mtdcore.c~linux-next-fixup drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~linux-next-fixup
+++ a/drivers/mtd/mtdcore.c
@@ -340,17 +340,6 @@ static struct device_type mtd_devtype =
 	.release	= mtd_release,
 };
 
-static int mtd_reboot_notifier(struct notifier_block *n, unsigned long state,
-			       void *cmd)
-{
-	struct mtd_info *mtd;
-
-	mtd = container_of(n, struct mtd_info, reboot_notifier);
-	mtd->_reboot(mtd);
-
-	return NOTIFY_DONE;
-}
-
 #ifndef CONFIG_MMU
 unsigned mtd_mmap_capabilities(struct mtd_info *mtd)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

