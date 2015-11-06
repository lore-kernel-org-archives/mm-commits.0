From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix.patch removed
 from -mm tree
Date: Thu, 05 Nov 2015 18:58:32 -0800
Message-ID: <563c1758.cD0k4p125hMnivK1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031090AbbKFC6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvme/host/pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/nvme/host/pci.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix drivers/nvme/host/pci.c
--- a/drivers/nvme/host/pci.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix
+++ a/drivers/nvme/host/pci.c
@@ -1025,11 +1025,11 @@ int __nvme_submit_sync_cmd(struct reques
 	req->special = (void *)0;
 
 	if (buffer && bufflen) {
-		ret = blk_rq_map_kern(q, req, buffer, bufflen, __GFP_WAIT);
+		ret = blk_rq_map_kern(q, req, buffer, bufflen, __GFP_RECLAIM);
 		if (ret)
 			goto out;
 	} else if (ubuffer && bufflen) {
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen, __GFP_WAIT);
+		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen, __GFP_RECLAIM);
 		if (ret)
 			goto out;
 		bio = req->bio;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
mm-vmstatc-uninline-node_page_state.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

