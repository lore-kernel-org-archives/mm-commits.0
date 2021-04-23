Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6ACC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 18:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A37A961425
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 18:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhDWSsg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Apr 2021 14:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhDWSsg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Apr 2021 14:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A2F0613B2;
        Fri, 23 Apr 2021 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619203678;
        bh=fE4yNrz7lAIGxXp/SC5DXlZ1WE1HO0hoW2UjnCb43W0=;
        h=Date:From:To:Subject:From;
        b=HnWVKLI8LKJiqZcnbcXrYQ4Mwp5PZIiBA9crPhpwHA1OqgWammHJYtZKrMx1l8Kwv
         ueiJ5ZcPxlKLdfaCZwvZojV7p3/zvQHROjeoUxjDOBcGPWU4j5hNrFLQS7ozD0uB/C
         MF4XZgURPk8ggBN1YfowVd2AqhW+ZzdiAjUWvSBU=
Date:   Fri, 23 Apr 2021 11:47:57 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210423184757.uUBM3fRBP%akpm@linux-foundation.org>
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
linux-next-git-rejects.patch

