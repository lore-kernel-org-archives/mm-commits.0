Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1312FC433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 23:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62696128E
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 23:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhEIXSx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 19:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229840AbhEIXSw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 19:18:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E30836128E;
        Sun,  9 May 2021 23:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620602269;
        bh=hjpqaiAlBj6swk8FUQMDXwejtjZp56IRb8/RuXSnqXA=;
        h=Date:From:To:Subject:From;
        b=s40rKJIbDhLTfoOZ6e60GEss4s+bluks4HOWWaO0Xe6QMBrnuX5F4QVuFk4yUqU4k
         arLz9WiCivpBuFbtbiuw+yeqI8hxpQ30tu+afUMACpk2gci1Np4/xOrX1DBUmDH64M
         Jh+QyBdwXTU9XdPzGfpP48J+0CXACcpfAChA90H8=
Date:   Sun, 09 May 2021 16:17:48 -0700
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, mm-commits@vger.kernel.org
Subject:  + mm-fix-typos-and-grammar-error-in-comments.patch added
 to -mm tree
Message-ID: <20210509231748.vPphTpEc5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typos and grammar error in comments
has been added to the -mm tree.  Its filename is
     mm-fix-typos-and-grammar-error-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-typos-and-grammar-error-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-typos-and-grammar-error-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm: fix typos and grammar error in comments

We moves tha -> We move that in mm/swap.c
statments -> statements in include/linux/mm.h

Link: https://lkml.kernel.org/r/20210509063444.GA24745@hyeyoo
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/swap.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-fix-typos-and-grammar-error-in-comments
+++ a/include/linux/mm.h
@@ -155,7 +155,7 @@ extern int mmap_rnd_compat_bits __read_m
 /* This function must be updated when the size of struct page grows above 80
  * or reduces below 56. The idea that compiler optimizes out switch()
  * statement, and only leaves move/store instructions. Also the compiler can
- * combine write statments if they are both assignments and can be reordered,
+ * combine write statements if they are both assignments and can be reordered,
  * this can result in several of the writes here being dropped.
  */
 #define	mm_zero_struct_page(pp) __mm_zero_struct_page(pp)
--- a/mm/swap.c~mm-fix-typos-and-grammar-error-in-comments
+++ a/mm/swap.c
@@ -554,7 +554,7 @@ static void lru_deactivate_file_fn(struc
 	} else {
 		/*
 		 * The page's writeback ends up during pagevec
-		 * We moves tha page into tail of inactive.
+		 * We move that page into tail of inactive.
 		 */
 		add_page_to_lru_list_tail(page, lruvec);
 		__count_vm_events(PGROTATED, nr_pages);
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-fix-typos-and-grammar-error-in-comments.patch

