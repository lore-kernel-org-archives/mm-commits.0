From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 28 Apr 2020 14:27:51 -0700
Message-ID: <20200428212751.NUcjqQ7PM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbgD1V1y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Apr 2020 17:27:54 -0400
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects-2

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |    3 -
 drivers/gpu/drm/i915/display/intel_display_power.c |   24 -----------
 drivers/gpu/drm/tidss/tidss_encoder.c              |   14 ------
 drivers/staging/vt6656/main_usb.c                  |    6 --
 include/linux/vermagic.h                           |    3 -
 sound/soc/soc-dapm.c                               |    8 ---
 6 files changed, 58 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4748,8 +4748,6 @@ amdgpu_dm_connector_late_register(struct
 	struct amdgpu_dm_connector *amdgpu_dm_connector =
 		to_amdgpu_dm_connector(connector);
 	int r;
-<<<<<<< HEAD
-=======
 
 	if ((connector->connector_type == DRM_MODE_CONNECTOR_DisplayPort) ||
 	    (connector->connector_type == DRM_MODE_CONNECTOR_eDP)) {
@@ -4758,7 +4756,6 @@ amdgpu_dm_connector_late_register(struct
 		if (r)
 			return r;
 	}
->>>>>>> linux-next/akpm-base
 
 	if ((connector->connector_type == DRM_MODE_CONNECTOR_DisplayPort) ||
 	    (connector->connector_type == DRM_MODE_CONNECTOR_eDP)) {
--- a/drivers/gpu/drm/i915/display/intel_display_power.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -4188,11 +4188,7 @@ static const struct i915_power_well_desc
 	{
 		.name = "AUX D TBT1",
 		.domains = TGL_AUX_D_TBT1_IO_POWER_DOMAINS,
-<<<<<<< HEAD
-		.ops = &icl_tc_phy_aux_power_well_ops,
-=======
 		.ops = &icl_aux_power_well_ops,
->>>>>>> linux-next/akpm-base
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4203,11 +4199,7 @@ static const struct i915_power_well_desc
 	{
 		.name = "AUX E TBT2",
 		.domains = TGL_AUX_E_TBT2_IO_POWER_DOMAINS,
-<<<<<<< HEAD
-		.ops = &icl_tc_phy_aux_power_well_ops,
-=======
 		.ops = &icl_aux_power_well_ops,
->>>>>>> linux-next/akpm-base
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4218,11 +4210,7 @@ static const struct i915_power_well_desc
 	{
 		.name = "AUX F TBT3",
 		.domains = TGL_AUX_F_TBT3_IO_POWER_DOMAINS,
-<<<<<<< HEAD
-		.ops = &icl_tc_phy_aux_power_well_ops,
-=======
 		.ops = &icl_aux_power_well_ops,
->>>>>>> linux-next/akpm-base
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4233,11 +4221,7 @@ static const struct i915_power_well_desc
 	{
 		.name = "AUX G TBT4",
 		.domains = TGL_AUX_G_TBT4_IO_POWER_DOMAINS,
-<<<<<<< HEAD
-		.ops = &icl_tc_phy_aux_power_well_ops,
-=======
 		.ops = &icl_aux_power_well_ops,
->>>>>>> linux-next/akpm-base
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4248,11 +4232,7 @@ static const struct i915_power_well_desc
 	{
 		.name = "AUX H TBT5",
 		.domains = TGL_AUX_H_TBT5_IO_POWER_DOMAINS,
-<<<<<<< HEAD
-		.ops = &icl_tc_phy_aux_power_well_ops,
-=======
 		.ops = &icl_aux_power_well_ops,
->>>>>>> linux-next/akpm-base
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
@@ -4263,11 +4243,7 @@ static const struct i915_power_well_desc
 	{
 		.name = "AUX I TBT6",
 		.domains = TGL_AUX_I_TBT6_IO_POWER_DOMAINS,
-<<<<<<< HEAD
-		.ops = &icl_tc_phy_aux_power_well_ops,
-=======
 		.ops = &icl_aux_power_well_ops,
->>>>>>> linux-next/akpm-base
 		.id = DISP_PW_ID_NONE,
 		{
 			.hsw.regs = &icl_aux_power_well_regs,
--- a/drivers/gpu/drm/tidss/tidss_encoder.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/tidss/tidss_encoder.c
@@ -66,13 +66,6 @@ static const struct drm_encoder_helper_f
 	.atomic_check = tidss_encoder_atomic_check,
 };
 
-<<<<<<< HEAD
-static const struct drm_encoder_funcs encoder_funcs = {
-	.destroy = tidss_encoder_destroy,
-};
-
-=======
->>>>>>> linux-next/akpm-base
 struct drm_encoder *tidss_encoder_create(struct tidss_device *tidss,
 					 u32 encoder_type, u32 possible_crtcs)
 {
@@ -85,15 +78,8 @@ struct drm_encoder *tidss_encoder_create
 
 	enc->possible_crtcs = possible_crtcs;
 
-<<<<<<< HEAD
-	ret = drm_encoder_init(&tidss->ddev, enc, &encoder_funcs,
-			       encoder_type, NULL);
-	if (ret < 0) {
-		kfree(enc);
-=======
 	ret = drm_simple_encoder_init(&tidss->ddev, enc, encoder_type);
 	if (ret < 0)
->>>>>>> linux-next/akpm-base
 		return ERR_PTR(ret);
 	}
 
--- a/drivers/staging/vt6656/main_usb.c~linux-next-git-rejects
+++ a/drivers/staging/vt6656/main_usb.c
@@ -740,14 +740,8 @@ static void vnt_bss_info_changed(struct
 		       BSS_CHANGED_ERP_SLOT))
 		vnt_set_bss_mode(priv);
 
-<<<<<<< HEAD
-	if (changed & BSS_CHANGED_TXPOWER)
-		vnt_rf_setpower(priv, priv->current_rate,
-				conf->chandef.chan->hw_value);
-=======
 	if (changed & (BSS_CHANGED_TXPOWER | BSS_CHANGED_BANDWIDTH))
 		vnt_rf_setpower(priv, conf->chandef.chan);
->>>>>>> linux-next/akpm-base
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		dev_dbg(&priv->usb->dev,
--- a/include/linux/vermagic.h~linux-next-git-rejects
+++ a/include/linux/vermagic.h
@@ -2,13 +2,10 @@
 #ifndef _LINUX_VERMAGIC_H
 #define _LINUX_VERMAGIC_H
 
-<<<<<<< HEAD
-=======
 #ifndef INCLUDE_VERMAGIC
 #error "This header can be included from kernel/module.c or *.mod.c only"
 #endif
 
->>>>>>> linux-next/akpm-base
 #include <generated/utsrelease.h>
 #include <asm/vermagic.h>
 
--- a/sound/soc/soc-dapm.c~linux-next-git-rejects
+++ a/sound/soc/soc-dapm.c
@@ -4427,19 +4427,11 @@ void snd_soc_dapm_connect_dai_link_widge
 		if (rtd->num_cpus == 1) {
 			for_each_rtd_codec_dais(rtd, i, codec_dai)
 				dapm_connect_dai_pair(card, rtd, codec_dai,
-<<<<<<< HEAD
-						      rtd->cpu_dais[0]);
-		} else if (rtd->num_codecs == rtd->num_cpus) {
-			for_each_rtd_codec_dais(rtd, i, codec_dai)
-				dapm_connect_dai_pair(card, rtd, codec_dai,
-						      rtd->cpu_dais[i]);
-=======
 						      asoc_rtd_to_cpu(rtd, 0));
 		} else if (rtd->num_codecs == rtd->num_cpus) {
 			for_each_rtd_codec_dais(rtd, i, codec_dai)
 				dapm_connect_dai_pair(card, rtd, codec_dai,
 						      asoc_rtd_to_cpu(rtd, i));
->>>>>>> linux-next/akpm-base
 		} else {
 			dev_err(card->dev,
 				"N cpus to M codecs link is not supported yet\n");
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
linux-next-git-rejects-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
