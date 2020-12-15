Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBCCC2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8708222473
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgLODNv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbgLODNm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:42 -0500
Date:   Mon, 14 Dec 2020 19:12:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001973;
        bh=TcD2ktfzqnXE3w/RRwh9EhW1251v9ogB1A6Gy7+htGU=;
        h=From:To:Subject:In-Reply-To:From;
        b=pgt14duRx7x/XeNlJq2F4kPMXxp6XXNDunQIWsCAK15qdu8WmlvcCiMplQcMuB88c
         EpQ0CJAo0JW7YmZKS/wpjKLG0P5p6FRN2MwwEXwJu3Xi5Fc0SGU+ukqjApnm+h7E1b
         sKBTzHFHmQeJTmvrwAbH5jPWPh7DxaMxybhcKSOA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        lonuxli.64@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 163/200] mm/migrate.c: fix comment spelling
Message-ID: <20201215031252.0w_23LAJj%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
