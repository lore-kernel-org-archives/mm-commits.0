Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F19C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 18:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFDDD20B1F
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 18:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbhAQSyd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 13:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728154AbhAQSyc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 13:54:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA00321D7F;
        Sun, 17 Jan 2021 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610909632;
        bh=K/6rWXmxaz+fXOM62j5C/yLN4ZLemItwhDs+2+VbUFs=;
        h=Date:From:To:Subject:From;
        b=S+eLTsXJIx2Tu12bIXKX5xWXcLhNBHH1HfWzDewEKgSw3OowPnCLPeSUGex9+IIb9
         u3aj7gau+YYwW4rCm7XJAQiqIkulgKNN5dLKOQZvY4scyy+ckpsGaq6pVCb8hChgvI
         9wwGueAxdIY15cG219aSyyTxyV6KL4r2rP4tuasI=
Date:   Sun, 17 Jan 2021 10:53:51 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210117185351.KgPUQ-fib%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -336,8 +336,6 @@ struct amdgpu_display_manager {
 	 */
 	const struct gpu_info_soc_bounding_box_v1_0 *soc_bounding_box;
 
-<<<<<<< HEAD
-=======
 	/**
 	 * @active_vblank_irq_count:
 	 *
@@ -345,7 +343,6 @@ struct amdgpu_display_manager {
 	 */
 	uint32_t active_vblank_irq_count;
 
->>>>>>> linux-next/akpm-base
 	/**
 	 * @mst_encoders:
 	 *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

