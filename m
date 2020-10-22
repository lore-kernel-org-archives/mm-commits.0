Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA0DC388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 996AE24673
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408235;
	bh=rSVxyfJYIB0dYfIRoATZMKHtpPJDhrWYPX7BqhHvsSo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tSfTNJNk4eH1CTKDVsa9wK5TcW8RYEjkBrJPMmGUojM2nOpLyZWpJA6/CY977UypA
	 At1eVB9HgA24NpmlFwMP4WIyxmSecJf/EyJRpSqB0wWtwdUZaD3wMC+OO3mTxVZ9YL
	 tZX1cJj2RAPXajRBPs6Le0vG6y/R94WW5WyFsvvw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373254AbgJVXKf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373268AbgJVXKf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:10:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9645420756;
        Thu, 22 Oct 2020 23:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408232;
        bh=rSVxyfJYIB0dYfIRoATZMKHtpPJDhrWYPX7BqhHvsSo=;
        h=Date:From:To:Subject:From;
        b=aRySPgglDW1RvrzqRaf60iETQM96IF4FBnjBho7XBzJNVy1hf4BKbfLf6U7TgBhw5
         lD0fQzkEUcPQVq3NG5WFXPGAN9cXNxFtyFy4cp55WloWodu+kkS093yWacpMWUkUVk
         vcJkedXnGUQ5xblLDq0fXGi/9uSsFcbtZz/BRNQI=
Date:   Thu, 22 Oct 2020 16:10:32 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, urezki@gmail.com
Subject:  [merged]
 mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch removed
 from -mm tree
Message-ID: <20201022231032.EDkczCj1-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the filename in the top of file comment in vmalloc.c
has been removed from the -mm tree.  Its filename was
     mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the filename in the top of file comment in vmalloc.c

No point in having the filename inside the file.

Link: https://lkml.kernel.org/r/20201002124035.1539300-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmalloc.c~mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc
+++ a/mm/vmalloc.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/vmalloc.c
- *
  *  Copyright (C) 1993  Linus Torvalds
  *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
  *  SMP-safe vmalloc/vfree/ioremap, Tigran Aivazian <tigran@veritas.com>, May 2000
_

Patches currently in -mm which might be from hch@lst.de are


