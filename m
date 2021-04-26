Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A652C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 26 Apr 2021 23:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08DF961178
	for <mm-commits@archiver.kernel.org>; Mon, 26 Apr 2021 23:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbhDZXhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Apr 2021 19:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhDZXhF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 26 Apr 2021 19:37:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C086044F;
        Mon, 26 Apr 2021 23:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619480183;
        bh=M94CYO4bNokS+MmIjNqwNOn7sVAQO+8MYddepnvFSBM=;
        h=Date:From:To:Subject:From;
        b=ocmoTZZ5NYKX0WVe9L00P6NiLGihQGWjYkBAQjUbUtvBA0K2W8tL+YnMMsNu3ouPN
         6Rzhlks2WFFzWuuUY2RUh4c2HpVdBvBo2eiL+qmMu6hxoZNhg5yzbHakABc36fwp71
         nqeGEjPqyOqY47ILkWA81e/kM2zpwAAuql9KsH9k=
Date:   Mon, 26 Apr 2021 16:36:22 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210426233622.28ck-UIzw%akpm@linux-foundation.org>
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

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4249,8 +4249,6 @@ static bool dm_plane_format_mod_supporte
 		return true;
 	}
 
-<<<<<<< HEAD
-=======
 	/* Check that the modifier is on the list of the plane's supported modifiers. */
 	for (i = 0; i < plane->modifier_count; i++) {
 		if (modifier == plane->modifiers[i])
@@ -4259,7 +4257,6 @@ static bool dm_plane_format_mod_supporte
 	if (i == plane->modifier_count)
 		return false;
 
->>>>>>> linux-next/akpm-base
 	/*
 	 * For D swizzle the canonical modifier depends on the bpp, so check
 	 * it here.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

