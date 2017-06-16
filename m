From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages-fix.patch removed from -mm tree
Date: Fri, 16 Jun 2017 14:00:35 -0700
Message-ID: <594446f3.3+xEOCpNZ8875j1I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdFPVAg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 17:00:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages-fix.patch

This patch was dropped because it was folded into mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages-fix

tweak comment text

Cc: Minchan Kim <minchan@kernel.org>
Cc: zhongjiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/vmpressure.c~mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages-fix mm/vmpressure.c
--- a/mm/vmpressure.c~mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages-fix
+++ a/mm/vmpressure.c
@@ -115,10 +115,9 @@ static enum vmpressure_levels vmpressure
 	unsigned long pressure = 0;
 
 	/*
-	 * reclaimed can be greater than scanned in cases
-	 * like reclaimed slab pages, shrink_node just add
-	 * reclaimed page without a related increment to
-	 * scanned pages.
+	 * reclaimed can be greater than scanned for things such as reclaimed
+	 * slab pages. shrink_node() just adds reclaimed pages without a
+	 * related increment to scanned pages.
 	 */
 	if (reclaimed >= scanned)
 		goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

