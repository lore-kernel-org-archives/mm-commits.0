Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1478FC4743E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E20D922D73
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgLOX7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:32898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729385AbgLOXZH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:07 -0500
Date:   Tue, 15 Dec 2020 15:22:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074569;
        bh=k5CQiqCBeMwwrnOP2CSOHgtBcd1EA/1cu4UnvN43ajo=;
        h=From:To:Subject:From;
        b=bCYS0d+Zg5tZBzOp4cOoCNTX48ikW+NfmkVp8AOWtkMhuHB51NmcDKaPcTa3RB14t
         RLl503ButifMlVdu/jG9bfavksvOTcwFP5i+zw+wgwdcIHmCWJWyutLzxZQe3q3dBC
         LaI1josHBUEiAhZNGYOSV0yh/7LVhnjq/5IppeCw=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hymmsx.yu@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-remove-the-filename-in-the-top-of-file-comment-in-vmscanc.patch removed
 from -mm tree
Message-ID: <20201215232249.RRl6G8r0y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: remove the filename in the top of file comment
has been removed from the -mm tree.  Its filename was
     mm-remove-the-filename-in-the-top-of-file-comment-in-vmscanc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "logic.yu" <hymmsx.yu@gmail.com>
Subject: mm/vmscan.c: remove the filename in the top of file comment

No point in having the filename inside the file.

Link: https://lkml.kernel.org/r/20201115141541.3878-1-hymmsx.yu@gmail.com
Signed-off-by: logic.yu <hymmsx.yu@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~mm-remove-the-filename-in-the-top-of-file-comment-in-vmscanc
+++ a/mm/vmscan.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *  linux/mm/vmscan.c
- *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  *
  *  Swap reorganised 29.12.95, Stephen Tweedie.
_

Patches currently in -mm which might be from hymmsx.yu@gmail.com are


