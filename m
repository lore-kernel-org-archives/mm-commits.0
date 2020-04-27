From: akpm@linux-foundation.org
Subject: + mm-gupc-updating-the-documentation-fix.patch added to
 -mm tree
Date: Mon, 27 Apr 2020 12:26:51 -0700
Message-ID: <20200427192651.BHBqOBoqF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgD0T0w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 15:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jrdr.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gupc-updating-the-documentation-fix
has been added to the -mm tree.  Its filename is
     mm-gupc-updating-the-documentation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gupc-updating-the-documentation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gupc-updating-the-documentation-fix.patch

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
Subject: mm-gupc-updating-the-documentation-fix

s@/*@/**@

Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gupc-updating-the-documentation-fix
+++ a/mm/gup.c
@@ -722,7 +722,7 @@ static struct page *follow_p4d_mask(stru
 	return follow_pud_mask(vma, address, p4d, flags, ctx);
 }
 
-/*
+/**
  * follow_page_mask - look up a page descriptor from a user-virtual address
  * @vma: vm_area_struct mapping @address
  * @address: virtual address to look up
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
