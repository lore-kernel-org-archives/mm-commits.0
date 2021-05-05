Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A3AC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEE4861078
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhEEBBO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231600AbhEEBBM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D0D61078;
        Wed,  5 May 2021 01:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176416;
        bh=GpnDQDl44hIxvNyMSF9mkZap6LsKyiNQrZFujv2B3QE=;
        h=Date:From:To:Subject:From;
        b=A7lu7N1tECIKKSy5tt+YCOE2eEy0N+IW4q/xq9l64vJFRXWFQJ8uCF0RvFzzsJ/Ja
         vXIbqdCE7NP9sfGstmje7gr3/6hDn4C4kOYNQfUTfKlh7h4tKKc7RBAAp75MZwSr6I
         tg87tiLfwi0WZaQGLfptyo27+4xPTz6La284p7GY=
Date:   Tue, 04 May 2021 18:00:16 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-page_alloc-minor-coding-style-tweaks.patch removed from -mm tree
Message-ID: <20210505010016.CFe0yEpbH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-minor-coding-style-tweaks.patch

This patch was dropped because it was folded into mm-mempool-minor-coding-style-tweaks.patch

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/page_alloc: minor coding style tweaks

Add whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1614228613-21754-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-minor-coding-style-tweaks
+++ a/mm/page_alloc.c
@@ -8808,7 +8808,7 @@ int alloc_contig_range(unsigned long sta
 	ret = __alloc_contig_migrate_range(&cc, start, end);
 	if (ret && ret != -EBUSY)
 		goto done;
-	ret =0;
+	ret = 0;
 
 	/*
 	 * Pages from [start, end) are within a MAX_ORDER_NR_PAGES
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-kasan-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-mempool-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-mlock-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch

