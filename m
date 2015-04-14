From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch removed from -mm
 tree
Date: Tue, 14 Apr 2015 15:17:48 -0700
Message-ID: <552d920c.F7eTq933YtcdVYQ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbbDNWRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:17:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-change-vunmap-to-tear-down-huge-kva-mappings-fix
has been removed from the -mm tree.  Its filename was
     mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch

This patch was dropped because it was folded into mm-change-vunmap-to-tear-down-huge-kva-mappings.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-change-vunmap-to-tear-down-huge-kva-mappings-fix

use consistent code layout

Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/pgtable.h~mm-change-vunmap-to-tear-down-huge-kva-mappings-fix include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-change-vunmap-to-tear-down-huge-kva-mappings-fix
+++ a/include/asm-generic/pgtable.h
@@ -711,8 +711,14 @@ static inline int pmd_set_huge(pmd_t *pm
 {
 	return 0;
 }
-static inline int pud_clear_huge(pud_t *pud) { return 0; }
-static inline int pmd_clear_huge(pmd_t *pmd) { return 0; }
+static inline int pud_clear_huge(pud_t *pud)
+{
+	return 0;
+}
+static inline int pmd_clear_huge(pmd_t *pmd)
+{
+	return 0;
+}
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 #endif /* !__ASSEMBLY__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition.patch
page_writeback-cleanup-mess-around-cancel_dirty_page.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch

