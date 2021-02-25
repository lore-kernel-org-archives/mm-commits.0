Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27320C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D462264E21
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhBYTVF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234559AbhBYTRK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A37E664F43;
        Thu, 25 Feb 2021 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280334;
        bh=AL72N5ylANcTMWC3OEP0xmcTvkn9JicjZN6imSljSM4=;
        h=Date:From:To:Subject:From;
        b=vBsNBf9eW5H1oF94iEcuHnw/0f/QYivK+kkZCypxPCUyLufXIT4CV2apbLJuySIC5
         mcu7SnUNwFJrif4z5+x3nneF42v1LrdXQvscr0D4qcVzKW1BzGKAr17gXEqjaiUiNa
         N6myvB0MZ0Y9qRKuS/2sVhPl6A49csktrAu7rdfo=
Date:   Thu, 25 Feb 2021 11:12:14 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org,
        rientjes@google.com
Subject:  [merged] mm-slub-minor-coding-style-tweaks.patch removed
 from -mm tree
Message-ID: <20210225191214.A4AtA1s3c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-slub-minor-coding-style-tweaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/slub: minor coding style tweaks

Add whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1612847403-5594-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-minor-coding-style-tweaks
+++ a/mm/slub.c
@@ -3269,7 +3269,7 @@ void kmem_cache_free_bulk(struct kmem_ca
 		if (!df.page)
 			continue;
 
-		slab_free(df.s, df.page, df.freelist, df.tail, df.cnt,_RET_IP_);
+		slab_free(df.s, df.page, df.freelist, df.tail, df.cnt, _RET_IP_);
 	} while (likely(size));
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are


