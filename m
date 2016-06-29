From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 28 Jun 2016 19:00:58 -0700
Message-ID: <57732bda.es0kYFEmGrOQfX1q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbcF2CA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_fbc.c  |    4 ----
 drivers/gpu/drm/sun4i/sun4i_drv.c |    7 -------
 drivers/gpu/drm/sun4i/sun4i_rgb.c |   11 -----------
 3 files changed, 22 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_fbc.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_fbc.c
--- a/drivers/gpu/drm/i915/intel_fbc.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_fbc.c
@@ -818,10 +818,6 @@ static bool intel_fbc_can_choose(struct
 {
 	struct drm_i915_private *dev_priv = crtc->base.dev->dev_private;
 	struct intel_fbc *fbc = &dev_priv->fbc;
-<<<<<<< HEAD
-	bool enable_by_default = IS_BROADWELL(dev_priv);
-=======
->>>>>>> linux-next/akpm-base
 
 	if (intel_vgpu_active(dev_priv)) {
 		fbc->no_fbc_reason = "VGPU is active";
diff -puN drivers/gpu/drm/sun4i/sun4i_drv.c~linux-next-git-rejects drivers/gpu/drm/sun4i/sun4i_drv.c
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -174,13 +174,6 @@ static int sun4i_drv_bind(struct device
 	if (ret)
 		goto free_drm;
 
-<<<<<<< HEAD
-	ret = drm_connector_register_all(drm);
-	if (ret)
-		goto unregister_drm;
-
-=======
->>>>>>> linux-next/akpm-base
 	return 0;
 
 free_drm:
diff -puN drivers/gpu/drm/sun4i/sun4i_rgb.c~linux-next-git-rejects drivers/gpu/drm/sun4i/sun4i_rgb.c
--- a/drivers/gpu/drm/sun4i/sun4i_rgb.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/sun4i/sun4i_rgb.c
@@ -95,17 +95,6 @@ static int sun4i_rgb_mode_valid(struct d
 	rounded_rate = clk_round_rate(tcon->dclk, rate);
 	if (rounded_rate < rate)
 		return MODE_CLOCK_LOW;
-<<<<<<< HEAD
-
-	if (rounded_rate > rate)
-		return MODE_CLOCK_HIGH;
-
-	DRM_DEBUG_DRIVER("Clock rate OK\n");
-
-	return MODE_OK;
-}
-=======
->>>>>>> linux-next/akpm-base
 
 	if (rounded_rate > rate)
 		return MODE_CLOCK_HIGH;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

