Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C599C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 04:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7D37613A9
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 04:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhDGEPZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Apr 2021 00:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhDGEPW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Apr 2021 00:15:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1832613BF;
        Wed,  7 Apr 2021 04:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617768909;
        bh=zr4GeHcJyMOrfJyg2Z3EVjAQMEhfJ3UX3Nzhsqh0eEg=;
        h=Date:From:To:Subject:From;
        b=AkuJQ17IFooumOqrggQtLT/yLfTmayQEKtJ+zlretskvS2IhHiaFli/Tch7r2j9gy
         2U4LzQ9htfTajm5MAB+TebtTs2jRe8Z+0VnPBcBbTngkF1gJl9EkbnhT1P7KGJktbD
         6zy6j9TTM28pvlMTEvHk7BL2XWfNm13CRHDiPLE0=
Date:   Tue, 06 Apr 2021 21:15:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, nyc@holomorphy.com,
        willy@infradead.org
Subject:  + old-email-addresses-in-mailmap.patch added to -mm tree
Message-ID: <20210407041509.OG_rX0Wsh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: .mailmap: fix old email addresses
has been added to the -mm tree.  Its filename is
     old-email-addresses-in-mailmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/old-email-addresses-in-mailmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/old-email-addresses-in-mailmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: .mailmap: fix old email addresses

Update Nick & Nadia's old addresses.

Link: https://lkml.kernel.org/r/20210406134036.GQ2531743@casper.infradead.org
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/.mailmap~old-email-addresses-in-mailmap
+++ a/.mailmap
@@ -254,8 +254,14 @@ Morten Welinder <welinder@anemone.rentec
 Morten Welinder <welinder@darter.rentec.com>
 Morten Welinder <welinder@troll.com>
 Mythri P K <mythripk@ti.com>
+Nadia Yvette Chambers <nyc@holomorphy.com> William Lee Irwin III <wli@holomorphy.com>
 Nathan Chancellor <nathan@kernel.org> <natechancellor@gmail.com>
 Nguyen Anh Quynh <aquynh@gmail.com>
+Nicholas Piggin <npiggin@gmail.com> <npiggen@suse.de>
+Nicholas Piggin <npiggin@gmail.com> <npiggin@kernel.dk>
+Nicholas Piggin <npiggin@gmail.com> <npiggin@suse.de>
+Nicholas Piggin <npiggin@gmail.com> <nickpiggin@yahoo.com.au>
+Nicholas Piggin <npiggin@gmail.com> <piggin@cyberone.com.au>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
_

Patches currently in -mm which might be from willy@infradead.org are

old-email-addresses-in-mailmap.patch
mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-introduce-and-use-mapping_empty.patch
mm-stop-accounting-shadow-entries.patch
dax-account-dax-entries-as-nrpages.patch
mm-remove-nrexceptional-from-inode.patch
mm-move-page_mapping_file-to-pagemaph.patch
mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch
mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch
mm-doc-turn-fault-flags-into-an-enum.patch
mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch
include-remove-pagemaph-from-blkdevh.patch

