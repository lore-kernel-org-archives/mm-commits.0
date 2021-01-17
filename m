Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FF5C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDC8222B3
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbhAQVUC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:20:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbhAQVUB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 16:20:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BF10222B3;
        Sun, 17 Jan 2021 21:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610918361;
        bh=qdg8EuOX9ka1HZSL6/DTFTEo3bIY+aD8dZ9qFn+wr8U=;
        h=Date:From:To:Subject:From;
        b=tiRi7poYDtbflbhoiXwPVpOB5C71sDH88E3ZQkFve2F2ugOBTra69AhZkX3eSBPjJ
         DeaSRYO/CQ/fMlopgHcNtSCyf6DUwWmRD7M4MLEcZgA3uXU1Vu3tJAKR1RJpuAvzGy
         m6sPT7GQ+t3Q3X0FSHIbQ3YB7NtKtKPT71JPt1Fs=
Date:   Sun, 17 Jan 2021 13:19:19 -0800
From:   akpm@linux-foundation.org
To:     cy.fan@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-migrate-remove-unneeded-semicolons.patch added to
 -mm tree
Message-ID: <20210117211919.AytZhJWXV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove unneeded semicolons
has been added to the -mm tree.  Its filename is
     mm-migrate-remove-unneeded-semicolons.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-remove-unneeded-semicolons.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-remove-unneeded-semicolons.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from cy.fan@huawei.com are

mm-migrate-remove-unneeded-semicolons.patch

