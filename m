Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B47C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 04:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA48361106
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 04:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhDIEcE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhDIEcD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 00:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 269896113A;
        Fri,  9 Apr 2021 04:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617942710;
        bh=M87C+odfgspACFJ30NH15+RUqrNuZs+mZblhYUYeA7M=;
        h=Date:From:To:Subject:From;
        b=petlbgVK9wr6jUsd/N4U1aEozZYgBE4aiL/l0sInM+YIU6KP1mtm5hlxOpBB/hsfq
         WT416BADTuWn7pHzxykMtIZEtDbdkMRF9ih2r3kmELfICcwQA9Lvd4YyCzXMdESMK1
         fGt2Cc1zVW+A7+uFux7PfHZg7Hmd9JOI8FaMQdVA=
Date:   Thu, 08 Apr 2021 21:31:49 -0700
From:   akpm@linux-foundation.org
To:     konishi.ryusuke@gmail.com, liu.xuzhi@zte.com.cn,
        mm-commits@vger.kernel.org
Subject:  + fs-nilfs2-fix-misspellings-using-codespell-tool.patch
 added to -mm tree
Message-ID: <20210409043149.Qlh6iqC0u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nilfs2: fix misspellings using codespell tool
has been added to the -mm tree.  Its filename is
     fs-nilfs2-fix-misspellings-using-codespell-tool.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-nilfs2-fix-misspellings-using-codespell-tool.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-nilfs2-fix-misspellings-using-codespell-tool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu xuzhi <liu.xuzhi@zte.com.cn>
Subject: fs/nilfs2: fix misspellings using codespell tool

Two typos are found out by codespell tool \
in 2217th and 2254th lines of segment.c:

$ codespell ./fs/nilfs2/
./segment.c:2217 :retured  ==> returned
./segment.c:2254: retured  ==> returned

Fix two typos found by codespell.

Link: https://lkml.kernel.org/r/1617864087-8198-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Liu xuzhi <liu.xuzhi@zte.com.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/segment.c~fs-nilfs2-fix-misspellings-using-codespell-tool
+++ a/fs/nilfs2/segment.c
@@ -2214,7 +2214,7 @@ static void nilfs_segctor_wakeup(struct
  * nilfs_construct_segment - construct a logical segment
  * @sb: super block
  *
- * Return Value: On success, 0 is retured. On errors, one of the following
+ * Return Value: On success, 0 is returned. On errors, one of the following
  * negative error code is returned.
  *
  * %-EROFS - Read only filesystem.
@@ -2251,7 +2251,7 @@ int nilfs_construct_segment(struct super
  * @start: start byte offset
  * @end: end byte offset (inclusive)
  *
- * Return Value: On success, 0 is retured. On errors, one of the following
+ * Return Value: On success, 0 is returned. On errors, one of the following
  * negative error code is returned.
  *
  * %-EROFS - Read only filesystem.
_

Patches currently in -mm which might be from liu.xuzhi@zte.com.cn are

fs-nilfs2-fix-misspellings-using-codespell-tool.patch

