Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1C6C43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6472764F25
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhBXUNM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235513AbhBXUK4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F27264EF1;
        Wed, 24 Feb 2021 20:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197429;
        bh=LRl9CRg1xZG87/rb0dwunkFiHMY6fzrAYDEuE1k7b2w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oUMOiWmuhO/1j6Z6W9fM7W86sDv+tbzoCwwt8aYx9jo1SffF3eE9m7UkTUOqnaqa1
         5om9fBWi60bm/6zQ3cB3PamFMp67oqCeAB7bwspCVV4pTMDW2iyW2EIVxe1dsg8FY2
         ybrFDcBNxUeimN0uoZNq/5mY4xDDBKjJJHOGAMZQ=
Date:   Wed, 24 Feb 2021 12:10:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cy.fan@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 173/173] mm/migrate: remove unneeded semicolons
Message-ID: <20210224201028._WSYzsUf7%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chengyang Fan <cy.fan@huawei.com>
Subject: mm/migrate: remove unneeded semicolons

Remove superfluous semicolons after function definitions.

Link: https://lkml.kernel.org/r/20210115110131.2359683-1-cy.fan@huawei.com
Signed-off-by: Chengyang Fan <cy.fan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/migrate.h~mm-migrate-remove-unneeded-semicolons
+++ a/include/linux/migrate.h
@@ -89,7 +89,7 @@ extern int PageMovable(struct page *page
 extern void __SetPageMovable(struct page *page, struct address_space *mapping);
 extern void __ClearPageMovable(struct page *page);
 #else
-static inline int PageMovable(struct page *page) { return 0; };
+static inline int PageMovable(struct page *page) { return 0; }
 static inline void __SetPageMovable(struct page *page,
 				struct address_space *mapping)
 {
_
