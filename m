From: akpm@linux-foundation.org
Subject: + mm-add-debug_wx-support-fix.patch added to -mm tree
Date: Mon, 27 Apr 2020 12:42:45 -0700
Message-ID: <20200427194245.oxRJKj3fn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgD0Tmq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 15:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: mm-add-debug_wx-support-fix
has been added to the -mm tree.  Its filename is
     mm-add-debug_wx-support-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-debug_wx-support-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-debug_wx-support-fix.patch

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
Subject: mm-add-debug_wx-support-fix

reword text, per Will Deacon & Zong Li

Cc: Will Deacon <will@kernel.org>
Cc: Zong Li <zong.li@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/Kconfig.debug~mm-add-debug_wx-support-fix
+++ a/mm/Kconfig.debug
@@ -128,8 +128,8 @@ config DEBUG_WX
 	help
 	  Generate a warning if any W+X mappings are found at boot.
 
-	  This is useful for discovering cases where the kernel is leaving
-	  W+X mappings after applying NX, as such mappings are a security risk.
+	  This is useful for discovering cases where the kernel is leaving W+X
+	  mappings after applying NX, as such mappings are a security risk.
 	  This check also includes UXN, which should be set on all kernel
 	  mappings.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
linux-next-git-rejects.patch
linux-next-git-rejects-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-add-debug_wx-support-fix.patch
