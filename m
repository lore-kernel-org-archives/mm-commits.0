From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Fri, 22 Nov 2013 13:13:20 -0800
Message-ID: <528fc8f0.tp3HBstd5Wk0x6dc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab3KVVNV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:13:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:13:20 -0800


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/mm_types.h~linux-next-rejects include/linux/mm_types.h
--- a/include/linux/mm_types.h~linux-next-rejects
+++ a/include/linux/mm_types.h
@@ -140,6 +140,9 @@ struct page {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
 		pgtable_t pmd_huge_pte; /* protected by page->ptl */
 #endif
+		struct rcu_head rcu_head;	/* Used by SLAB
+						 * when destroying via RCU
+						 */
 	};
 
 	/* Remainder is not double word aligned */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
arch-um-kernel-sysrqc-rename-print_stack_trace.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

