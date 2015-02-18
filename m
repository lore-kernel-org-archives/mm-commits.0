From: akpm@linux-foundation.org
Subject: + linux-next-fixup.patch added to -mm tree
Date: Wed, 18 Feb 2015 15:46:34 -0800
Message-ID: <54e5245a.UxRSTWCd/TmywQhK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbbBRXqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 18:46:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-fixup
has been added to the -mm tree.  Its filename is
     linux-next-fixup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-fixup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-fixup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-fixup.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

