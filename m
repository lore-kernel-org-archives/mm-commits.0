From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects-fix.patch added to -mm tree
Date: Sat, 25 Apr 2020 23:53:39 -0700
Message-ID: <20200426065339.j6aIMJyZ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgDZGxk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 26 Apr 2020 02:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects-fix
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects-fix.patch

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
Subject: linux-next-git-rejects-fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/tidss/tidss_encoder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/tidss/tidss_encoder.c~linux-next-git-rejects-fix
+++ a/drivers/gpu/drm/tidss/tidss_encoder.c
@@ -79,7 +79,7 @@ struct drm_encoder *tidss_encoder_create
 	enc->possible_crtcs = possible_crtcs;
 
 	ret = drm_simple_encoder_init(&tidss->ddev, enc, encoder_type);
-	if (ret < 0)
+	if (ret < 0) {
 		return ERR_PTR(ret);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch
linux-next-git-rejects-fix.patch
