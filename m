From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects-fix.patch removed from
 -mm tree
Date: Tue, 28 Apr 2020 14:27:58 -0700
Message-ID: <20200428212758._RAvCHrhg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgD1V17 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Apr 2020 17:27:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects-fix
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects-fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/tidss/tidss_encoder.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/tidss/tidss_encoder.c~linux-next-git-rejects-fix
+++ a/drivers/gpu/drm/tidss/tidss_encoder.c
@@ -81,7 +81,6 @@ struct drm_encoder *tidss_encoder_create
 	ret = drm_simple_encoder_init(&tidss->ddev, enc, encoder_type);
 	if (ret < 0)
 		return ERR_PTR(ret);
-	}
 
 	drm_encoder_helper_add(enc, &encoder_helper_funcs);
 
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
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
