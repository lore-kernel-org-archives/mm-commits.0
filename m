From: akpm@linux-foundation.org
Subject: + arm64-use-set_memoryh-header-fix.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:50:04 -0800
Message-ID: <58ba012c.wvmHlxfNhMslYh2j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58970 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752282AbdCCXuF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:50:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, linux@armlinux.org.uk, mark.rutland@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-use-set_memoryh-header-fix
has been added to the -mm tree.  Its filename is
     arm64-use-set_memoryh-header-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-use-set_memoryh-header-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-use-set_memoryh-header-fix.patch

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
Subject: arm64-use-set_memoryh-header-fix

alpha-sort includes, per Mark

Cc: Laura Abbott <labbott@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm64/mm/pageattr.c~arm64-use-set_memoryh-header-fix arch/arm64/mm/pageattr.c
--- a/arch/arm64/mm/pageattr.c~arm64-use-set_memoryh-header-fix
+++ a/arch/arm64/mm/pageattr.c
@@ -17,8 +17,8 @@
 #include <linux/vmalloc.h>
 
 #include <asm/pgtable.h>
-#include <asm/tlbflush.h>
 #include <asm/set_memory.h>
+#include <asm/tlbflush.h>
 
 struct page_change_data {
 	pgprot_t set_mask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
treewide-move-set_memory_-functions-away-from-cacheflushh-fix.patch
arm64-use-set_memoryh-header-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

