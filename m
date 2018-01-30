From: akpm@linux-foundation.org
Subject: [folded-merged]
 net-netfilter-x_tablesc-make-allocation-less-aggressive-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 30 Jan 2018 11:29:39 -0800
Message-ID: <5a70c7a3.YX/vgdh11qvQ10Sd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753695AbeA3T3k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jan 2018 14:29:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, fw@strlen.de, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: net-netfilter-x_tablesc-make-allocation-less-aggressive-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     net-netfilter-x_tablesc-make-allocation-less-aggressive-checkpatch-fixes.patch

This patch was dropped because it was folded into net-netfilter-x_tablesc-make-allocation-less-aggressive.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net-netfilter-x_tablesc-make-allocation-less-aggressive-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#6: 
as well.  eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc() in

WARNING: networking block comments don't use an empty /* line, use /* Comment...
#35: FILE: net/netfilter/x_tables.c:1012:
+	/*
+	 * __GFP_NORETRY is not fully supported by kvmalloc but it should

total: 1 errors, 1 warnings, 0 checks, 14 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/net-netfilter-x_tablesc-make-allocation-less-aggressive.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/x_tables.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN net/netfilter/x_tables.c~net-netfilter-x_tablesc-make-allocation-less-aggressive-checkpatch-fixes net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~net-netfilter-x_tablesc-make-allocation-less-aggressive-checkpatch-fixes
+++ a/net/netfilter/x_tables.c
@@ -1008,8 +1008,7 @@ struct xt_table_info *xt_alloc_table_inf
 	if ((size >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
-	/*
-	 * __GFP_NORETRY is not fully supported by kvmalloc but it should
+	/* __GFP_NORETRY is not fully supported by kvmalloc but it should
 	 * work reasonably well if sz is too large and bail out rather
 	 * than shoot all processes down before realizing there is nothing
 	 * more to reclaim.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
net-netfilter-x_tablesc-make-allocation-less-aggressive.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

