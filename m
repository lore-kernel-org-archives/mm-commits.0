Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D799C4332D
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 750C864F2B
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhBYThd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235019AbhBYTfT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9822F64F41;
        Thu, 25 Feb 2021 19:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280771;
        bh=ACjl0rHgoBcMTU0B3T1XMuBdMnmf3L+RGcm2/Q3UUPg=;
        h=Date:From:To:Subject:From;
        b=BuHEtuOGW3J5N8CFZjj0tQfiqlVtC0W6xREtWcU4ZdQ/svpHCvV8buCipRVnfk/6o
         I/P5YOwl0ehH0hNwBhjpr6VOE9qtxPGNpfnWI2MZ2ubmykmCSvfG5GeDKa1yXxIDi8
         yYoe+Fmkaca8wlnIJuDe6epQJE7l1XBlrQuBOIJ0=
Date:   Thu, 25 Feb 2021 11:19:31 -0800
From:   akpm@linux-foundation.org
To:     cy.fan@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-migrate-remove-unneeded-semicolons.patch
 removed from -mm tree
Message-ID: <20210225191931.lAlEmeOHf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove unneeded semicolons
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-unneeded-semicolons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


