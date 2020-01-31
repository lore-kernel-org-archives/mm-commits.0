From: akpm@linux-foundation.org
Subject: + asm-generic-tlb-rename-have_rcu_table_free-fix.patch
 added to -mm tree
Date: Thu, 30 Jan 2020 17:21:30 -0800
Message-ID: <20200131012130.4CJ01FzTD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbgAaBVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Jan 2020 20:21:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, lkp@intel.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org


The patch titled
     Subject: asm-generic-tlb-rename-have_rcu_table_free-fix
has been added to the -mm tree.  Its filename is
     asm-generic-tlb-rename-have_rcu_table_free-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-tlb-rename-have_rcu_table_free-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-tlb-rename-have_rcu_table_free-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm.patch
mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-fix.patch
linux-next-git-rejects.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
asm-generic-tlb-rename-have_rcu_table_free-fix.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
a.patch
