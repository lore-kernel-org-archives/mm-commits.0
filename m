Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987F0C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A06D64F02
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhCDBR1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:17:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231560AbhCDBRG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:17:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 914B464E02;
        Thu,  4 Mar 2021 01:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614820585;
        bh=2eA3RMMssVZ8XRe91ngPXdkkSUCjoVYoThoGhAIRghc=;
        h=Date:From:To:Subject:From;
        b=zMPXfnzt68SF/id5r1ME7xaPpF/hYYUHmLD2ufYOLuzyo2aERHTMvjZMfSr8jHYpF
         LWFmtNXO1OGaaUdymDU6ZIOCLIDlvfO/4N24J9HPvIEaqNpELtXM3qdc/gmWsd9jWd
         TaPKeaPCbE5qsPthrIkwIJnQraqNOqN1mVLG/m6k=
Date:   Wed, 03 Mar 2021 17:16:25 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  + mm-mempool-minor-coding-style-tweaks.patch added to -mm
 tree
Message-ID: <20210304011625.0iSHYoh7F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: minor coding style tweaks
has been added to the -mm tree.  Its filename is
     mm-mempool-minor-coding-style-tweaks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-minor-coding-style-tweaks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-minor-coding-style-tweaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/mempool: minor coding style tweaks

Add whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1614222374-13805-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempool.c~mm-mempool-minor-coding-style-tweaks
+++ a/mm/mempool.c
@@ -251,7 +251,7 @@ EXPORT_SYMBOL(mempool_init);
 mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
 				mempool_free_t *free_fn, void *pool_data)
 {
-	return mempool_create_node(min_nr,alloc_fn,free_fn, pool_data,
+	return mempool_create_node(min_nr, alloc_fn, free_fn, pool_data,
 				   GFP_KERNEL, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(mempool_create);
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-swapfile-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-mlock-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch
mm-mempool-minor-coding-style-tweaks.patch

