Return-Path: <SRS0=DYKa=DF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FB9C2D0A8
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 19:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 471E22074B
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601321541;
	bh=UxGPkIse8LRJiDGewaXCpIhFhEi54GcmsohmzHEtuMg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sB1Pt/E4F1Vny0wlPPdVgxrZ849l/ujNoeyOOzAWxOKqX32sSUNkJzYZvwcqBVZ2g
	 ntVNbuqFeQEDj0+TBlF1WQudmR+z/sGIPNL2YImminxN1jbaVGGERrYXpZXR2vhICF
	 zYsSTYMaH03bs5TeygNbkpawQ45cUX+GmspzccCI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgI1TcV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 15:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgI1TcU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 15:32:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4603B2074A;
        Mon, 28 Sep 2020 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601321540;
        bh=UxGPkIse8LRJiDGewaXCpIhFhEi54GcmsohmzHEtuMg=;
        h=Date:From:To:Subject:From;
        b=CQuVNhaCCDZJj0pKDnNu+BZvpbW9vgkQoOBRIAdmgHZMJLZUKQ1HVYX/moOO3Ozer
         CpndmJFw0TQg9ekboFNxt10vSfGWLFEjy/wUpHQLX3cqJGwqASWl+7wByQVbe85nbE
         p/tSjjJDhL7oSlUGHqMqTIz1Rk5E482/KrwtLJUg=
Date:   Mon, 28 Sep 2020 12:32:19 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20200928193219.XYFCue8xw%akpm@linux-foundation.org>
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

 drivers/base/regmap/regmap.c                     |    3 ---
 drivers/gpu/drm/i915/selftests/mock_gem_device.c |    4 ----
 2 files changed, 7 deletions(-)

--- a/drivers/base/regmap/regmap.c~linux-next-git-rejects
+++ a/drivers/base/regmap/regmap.c
@@ -722,11 +722,8 @@ struct regmap *__regmap_init(struct devi
 	ret = regmap_set_name(map, config);
 	if (ret)
 		goto err_map;
-<<<<<<< HEAD
-=======
 
 	ret = -EINVAL; /* Later error paths rely on this */
->>>>>>> linux-next/akpm-base
 
 	if (config->disable_locking) {
 		map->lock = map->unlock = regmap_lock_unlock_none;
--- a/drivers/gpu/drm/i915/selftests/mock_gem_device.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/selftests/mock_gem_device.c
@@ -121,10 +121,6 @@ struct drm_i915_private *mock_gem_device
 #endif
 	struct drm_i915_private *i915;
 	struct pci_dev *pdev;
-<<<<<<< HEAD
-	int err;
-=======
->>>>>>> linux-next/akpm-base
 
 	pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
 	if (!pdev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

