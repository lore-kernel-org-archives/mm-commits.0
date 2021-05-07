Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD71C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A419F61289
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhEGBEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhEGBEd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82226610F7;
        Fri,  7 May 2021 01:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349414;
        bh=ueVxieuGAlkwkAYMeMWzegGv41FNdt1tdzQ1KYx93j8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sBKsX70Ner9j6l9b4xoEj4YUscu75EEntaqzG3Rnbm76GJT5yYBKIAO+XM/zKS2c+
         f9Gx0URjYi2zVbKYoAjHFW+JjwnLDbebv6SWuEM8BgBq+G3jvV1mECeoiYktGXAbSX
         23dWRWjcFqagMzD4cQiZuUXsRL9Akyp/cMqlWSk8=
Date:   Thu, 06 May 2021 18:03:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        unixbhaskar@gmail.com
Subject:  [patch 29/91] lib/genalloc.c: fix a typo
Message-ID: <20210507010334.hiaNAQDM7%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: lib/genalloc.c: Fix a typo

s/macthing/matching/

Link: https://lkml.kernel.org/r/20210326131530.30481-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/genalloc.c~lib-genallocc-fix-a-typo
+++ a/lib/genalloc.c
@@ -735,7 +735,7 @@ EXPORT_SYMBOL(gen_pool_first_fit_order_a
 
 /**
  * gen_pool_best_fit - find the best fitting region of memory
- * macthing the size requirement (no alignment constraint)
+ * matching the size requirement (no alignment constraint)
  * @map: The address to base the search on
  * @size: The bitmap size in bits
  * @start: The bitnumber to start searching at
_
