From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memblock-add-debug-output-for-the-memblock_add-fix.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 15:41:20 -0700
Message-ID: <552ee910.u5DjNGR/A2mGdpL2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbbDOWlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Emilian.Medve@freescale.com, akinobu.mita@gmail.com, catalin.marinas@arm.com, fabf@skynet.be, kuleshovmail@gmail.com, phacht@linux.vnet.ibm.com, schwidefsky@de.ibm.com, tangchen@cn.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memblock-add-debug-output-for-the-memblock_add-fix
has been removed from the -mm tree.  Its filename was
     mm-memblock-add-debug-output-for-the-memblock_add-fix.patch

This patch was dropped because it was folded into mm-memblock-add-debug-output-for-the-memblock_add.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memblock-add-debug-output-for-the-memblock_add-fix

s/memblock_memory/memblock_add/ in message

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Emil Medve <Emilian.Medve@freescale.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblock-add-debug-output-for-the-memblock_add-fix mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-debug-output-for-the-memblock_add-fix
+++ a/mm/memblock.c
@@ -587,7 +587,7 @@ static int __init_memblock memblock_add_
 {
 	struct memblock_type *_rgn = &memblock.memory;
 
-	memblock_dbg("memblock_memory: [%#016llx-%#016llx] flags %#02lx %pF\n",
+	memblock_dbg("memblock_add: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size - 1,
 		     flags, (void *)_RET_IP_);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-memblock-add-debug-output-for-the-memblock_add.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction-fix.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

