Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020E4C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 18:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAF1B22CAD
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 18:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390432AbhASScv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 13:32:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390818AbhASScs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 13:32:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC04B22DD3;
        Tue, 19 Jan 2021 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611081097;
        bh=yKhtYtac+pFcxrMOzxchZhqj0GrG5xlocX27Oku0xIE=;
        h=Date:From:To:Subject:From;
        b=RAa/WiMBxUtF6n14kQ70DsUPlgFClUbALkvaY7HA5cfniJi9I/4qMrBtcla3+ULX6
         /WQxEbmO0kjMaC8euukuqDK5J345bhozYF7A6lLNop5jdEOM6e9O0GudmxumYgzvpP
         35Q+pIr2BC0FDoydMl7gy6Gr9nVGb5a8i3NCz984=
Date:   Tue, 19 Jan 2021 10:31:37 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210119183137.C6KeEhsPQ%akpm@linux-foundation.org>
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
mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
initramfs-panic-with-memory-information-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

