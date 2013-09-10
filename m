From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-include-linux-schedh-in-asm-uaccessh.patch
 removed from -mm tree
Date: Tue, 10 Sep 2013 16:52:20 -0700
Message-ID: <522fb0b4.WNdVdEuS+e5pOMaQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3IJXwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 19:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl, ak@linux.intel.com

Subject: [to-be-updated] x86-include-linux-schedh-in-asm-uaccessh.patch removed from -mm tree
To: ak@linux.intel.com,a.p.zijlstra@chello.nl,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 16:52:20 -0700


The patch titled
     Subject: x86: include linux/sched.h in asm/uaccess.h
has been removed from the -mm tree.  Its filename was
     x86-include-linux-schedh-in-asm-uaccessh.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: x86: include linux/sched.h in asm/uaccess.h

uaccess.h uses might_sleep, but there is currently no explicit include for
this.  Since a upcoming patch moves might_sleep into sched.h include
sched.h here.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/include/asm/uaccess.h~x86-include-linux-schedh-in-asm-uaccessh arch/x86/include/asm/uaccess.h
--- a/arch/x86/include/asm/uaccess.h~x86-include-linux-schedh-in-asm-uaccessh
+++ a/arch/x86/include/asm/uaccess.h
@@ -3,6 +3,7 @@
 /*
  * User space memory access functions
  */
+#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/compiler.h>
 #include <linux/thread_info.h>
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch
lto-watchdog-hpwdtc-make-assembler-label-global.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
tree-sweep-include-linux-schedh-for-might_sleep-users.patch
sched-mark-should_resched-__always_inline.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

