Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE321C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 05:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C18C961601
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 05:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhCLFbZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 00:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231725AbhCLFav (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 00:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA2B161601;
        Fri, 12 Mar 2021 05:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615527045;
        bh=H0MYxduFq5m2OPYlFtH59R7Lt4l+meol3XCrjrQ0d2Q=;
        h=Date:From:To:Subject:From;
        b=KhWq5ycnXC0b8u5x7oXhLnxZ0fzCVMv9m2laPCsb5C/CWgUAOLKYpsKOkFZspq+TZ
         zNq5s2ku69LV8PUA2UNRTvkpFN16/P6tWtincoYbAZO9WbhnMt8rVmtz2qAV+EKyXR
         flP570EmO/hf25e2Bu4qoQJqg0FpmcJp3upRBQtI=
Date:   Thu, 11 Mar 2021 21:30:45 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210312053045.4Zmljmxxd%akpm@linux-foundation.org>
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

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3339,21 +3339,12 @@ static int amdgpu_dm_backlight_get_brigh
 
 	amdgpu_dm_update_backlight_caps(dm);
 	caps = dm->backlight_caps;
-<<<<<<< HEAD
 
 	if (caps.aux_support) {
 		struct dc_link *link = (struct dc_link *)dm->backlight_link;
 		u32 avg, peak;
 		bool rc;
 
-=======
-
-	if (caps.aux_support) {
-		struct dc_link *link = (struct dc_link *)dm->backlight_link;
-		u32 avg, peak;
-		bool rc;
-
->>>>>>> linux-next/akpm-base
 		rc = dc_link_get_backlight_level_nits(link, &avg, &peak);
 		if (!rc)
 			return bd->props.brightness;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

