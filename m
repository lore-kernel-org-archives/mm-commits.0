From: akpm@linux-foundation.org
Subject: [folded-merged]
 asm-generic-tlb-rename-have_rcu_table_free-fix.patch removed from -mm tree
Date: Mon, 03 Feb 2020 17:12:05 -0800
Message-ID: <20200204011205.9ujgwz_jR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbgBDBMG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:12:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, lkp@intel.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org


The patch titled
     Subject: asm-generic-tlb-rename-have_rcu_table_free-fix
has been removed from the -mm tree.  Its filename was
     asm-generic-tlb-rename-have_rcu_table_free-fix.patch

This patch was dropped because it was folded into asm-generic-tlb-rename-have_rcu_table_free.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: asm-generic-tlb-rename-have_rcu_table_free-fix

fix sparc64 Kconfig

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/Kconfig~asm-generic-tlb-rename-have_rcu_table_free-fix
+++ a/arch/sparc/Kconfig
@@ -64,7 +64,7 @@ config SPARC64
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
-	select MMU_GATHER_RCU_TABLE_FREE
+	select MMU_GATHER_RCU_TABLE_FREE if SMP
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_DYNAMIC_FTRACE
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-consolidate-all-xxxctl_down-functions.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
asm-generic-tlb-rename-have_rcu_table_free.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
