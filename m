Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64874C388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14A022344C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2TGS1LD2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgKPXHp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 18:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgKPXHp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 18:07:45 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98B922244C;
        Mon, 16 Nov 2020 23:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605568064;
        bh=PkMe6qJnA+bodiD+yJkgiv4J0YDBfTF7O95ovsNeMi8=;
        h=Date:From:To:Subject:From;
        b=2TGS1LD2QPHBRFvNdXP2AA0rLS4WO6zpDCc7UxqLcVVfh9XS2eO1VCQdgf5LzRvBL
         2FKCnNhTB7mEnRiDceezUI9Oza/QgX/fbouCfpav/HJvkHUwviVxGrnjCZ2wUfo/t6
         SsA0iHDX7hl3KZ2mPoaGtp6CKF0mCf8tVUV4d7Nw=
Date:   Mon, 16 Nov 2020 15:07:44 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hymmsx.yu@gmail.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-remove-the-filename-in-the-top-of-file-comment-in-vmscanc.patch added to
 -mm tree
Message-ID: <20201116230744.84awwGlDm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: remove the filename in the top of file comment
has been added to the -mm tree.  Its filename is
     mm-remove-the-filename-in-the-top-of-file-comment-in-vmscanc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-filename-in-the-top-of-file-comment-in-vmscanc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-filename-in-the-top-of-file-comment-in-vmscanc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove-the-filename-in-the-top-of-file-comment-in-vmscanc.patch

