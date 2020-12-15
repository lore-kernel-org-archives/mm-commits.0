Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C51C2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C995322D07
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgLOX7q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgLOX0F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:05 -0500
Date:   Tue, 15 Dec 2020 15:23:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074594;
        bh=OWqCNzVb9cl7EeMcEDAVudHKb54PQrOxL0zt0lUc+Vc=;
        h=From:To:Subject:From;
        b=Ofc+HIKlwa+4SX4ND1t09PTlpp0B6XBY3ECtUn8wUOQeF2eO+n+brjSDEAZEOhykk
         BvJiwNYv18+TLY6G3Oq+eEefXMKRsPr1yVyHKzhK9CfJGVvQfA5E7h6gF98EZLrb3x
         X7NTmRaW8+iASDyae9J3xvs/eqsc7x3xqc30SkQk=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, lonuxli.64@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-migrate-fix-comment-spelling.patch removed
 from -mm tree
Message-ID: <20201215232314.pGr3OJNEt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: fix comment spelling
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-comment-spelling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Long Li <lonuxli.64@gmail.com>
Subject: mm/migrate.c: fix comment spelling

The word in the comment is misspelled, it should be "include".

Link: https://lkml.kernel.org/r/20201024114144.GA20552@lilong
Signed-off-by: Long Li <lonuxli.64@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-comment-spelling
+++ a/mm/migrate.c
@@ -1696,7 +1696,7 @@ static int move_pages_and_store_status(s
 		 * Positive err means the number of failed
 		 * pages to migrate.  Since we are going to
 		 * abort and return the number of non-migrated
-		 * pages, so need to incude the rest of the
+		 * pages, so need to include the rest of the
 		 * nr_pages that have not been attempted as
 		 * well.
 		 */
_

Patches currently in -mm which might be from lonuxli.64@gmail.com are


