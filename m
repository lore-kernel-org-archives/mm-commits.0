Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B89AC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D43E564F2F
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhBXUDj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235375AbhBXUCv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 833DA64F2B;
        Wed, 24 Feb 2021 20:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196886;
        bh=N2W9qplJMuNdg0y15XwwMPC2Ssu4JtA+NY3o9xSBvoA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q957SYxiQ0X2k8dtvnLMNgdP1YwqynVQ6ZnGxhBm5lHpk8oRKAigO5uuuO0tVqbYI
         v3JFObP6bjMZxp8bYfPD2nzGIANryESHD0dcmrTbiy+JjoL/lCFh8WAmfW4qlyvuNv
         IKAMUfI2NOAw5yhQxYMEAMLQXcosGfkDhhMtHcOY=
Date:   Wed, 24 Feb 2021 12:01:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daizhiyuan@phytium.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org
Subject:  [patch 023/173] mm/slub: minor coding style tweaks
Message-ID: <20210224200126.NFkZDiLL2%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
