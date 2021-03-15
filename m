Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB2EC43381
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BBE664F0D
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhCOR4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232191AbhCORsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6411564EED;
        Mon, 15 Mar 2021 17:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830456;
        bh=ZtQ+1sbHVr+1ngmA/b0+LEABMWqdjMAUukhwQ1XXvP4=;
        h=Date:From:To:Subject:From;
        b=foLxW094sxAx7yrnpzD/f0f52bTFcZ9tO1VxcZcm+9y+Eo/8yAoN5S7ek5l1wPm1A
         NLGCV4PbTcevKwbbdMEK6Z/j4gfOKC94DKTe2/rpImIbdITFJIGe/OmTltwD1rKKKU
         Dh3DLziD2t+/BtmGsTbQM4YQerCNStrSRRxAvmeM=
Date:   Mon, 15 Mar 2021 10:47:35 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210315174735.DYAW1qkKQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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

 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c |    3 ---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c |    3 ---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c |    7 -------
 3 files changed, 13 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -1546,8 +1546,6 @@ static int vega10_override_pcie_paramete
 			pp_table->PcieLaneCount[i] = pcie_width;
 	}
 
-<<<<<<< HEAD
-=======
 	if (data->registry_data.pcie_dpm_key_disabled) {
 		for (i = 0; i < NUM_LINK_LEVELS; i++) {
 			pp_table->PcieGenSpeed[i] = pcie_gen;
@@ -1555,7 +1553,6 @@ static int vega10_override_pcie_paramete
 		}
 	}
 
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
@@ -540,8 +540,6 @@ static int vega12_override_pcie_paramete
 		pp_table->PcieLaneCount[i] = pcie_width_arg;
 	}
 
-<<<<<<< HEAD
-=======
 	/* override to the highest if it's disabled from ppfeaturmask */
 	if (data->registry_data.pcie_dpm_key_disabled) {
 		for (i = 0; i < NUM_LINK_LEVELS; i++) {
@@ -565,7 +563,6 @@ static int vega12_override_pcie_paramete
 		data->smu_features[GNLD_DPM_LINK].enabled = false;
 		data->smu_features[GNLD_DPM_LINK].supported = false;
 	}
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -879,12 +879,6 @@ static int vega20_override_pcie_paramete
 				"[OverridePcieParameters] Attempt to override pcie params failed!",
 				return ret);
 		}
-<<<<<<< HEAD
-
-		/* update the pptable */
-		pp_table->PcieGenSpeed[i] = pcie_gen_arg;
-		pp_table->PcieLaneCount[i] = pcie_width_arg;
-=======
 
 		/* update the pptable */
 		pp_table->PcieGenSpeed[i] = pcie_gen_arg;
@@ -913,7 +907,6 @@ static int vega20_override_pcie_paramete
 				return ret);
 		data->smu_features[GNLD_DPM_LINK].enabled = false;
 		data->smu_features[GNLD_DPM_LINK].supported = false;
->>>>>>> linux-next/akpm-base
 	}
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

