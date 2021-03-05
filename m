Return-Path: <SRS0=/uUQ=ID=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F2DC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 23:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04B61650A0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 23:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhCEXFV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Mar 2021 18:05:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhCEXFE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Mar 2021 18:05:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17CA96509B;
        Fri,  5 Mar 2021 23:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614985504;
        bh=R4kQ5+TY9mHYLwkETZjoH8/rRc6sFODJEjd0SlweEe4=;
        h=Date:From:To:Subject:From;
        b=ozgl27NSJNcABMkxune4UX4MGZrFw/gGUtMyUQ91zxpFxZ9vJVpuIbFn6qa95SspS
         KS2UCX2XwXrNmvWcOgqhW5pqLlBlwxm0+K8HmJHExynSHRGfZzdzub7KxUm2RdJ+mJ
         yL1xhyMAfTdCaqJVRJQ6SQHcpeIjYaHzWNUMMD/k=
Date:   Fri, 05 Mar 2021 15:05:03 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210305230503.HBzm8sAXZ%akpm@linux-foundation.org>
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

 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -77,12 +77,9 @@ MODULE_FIRMWARE("amdgpu/dimgrey_cavefish
 
 #define mmTHM_BACO_CNTL_ARCT			0xA7
 #define mmTHM_BACO_CNTL_ARCT_BASE_IDX		0
-<<<<<<< HEAD
 
 static int link_width[] = {0, 1, 2, 4, 8, 12, 16};
 static int link_speed[] = {25, 50, 80, 160};
-=======
->>>>>>> linux-next/akpm-base
 
 int smu_v11_0_init_microcode(struct smu_context *smu)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

