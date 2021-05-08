Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4E0C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E268961402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhEHWy1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhEHWy0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82F9B60E0B;
        Sat,  8 May 2021 22:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514404;
        bh=vImt75HXfuIWaPLdKBuK8KDRGF3PWy3BaEoUaNCczv4=;
        h=Date:From:To:Subject:From;
        b=KFo+Ou7gVTxpN8JEP5wMQjQ0fmJ8ehWJEPueWj7O3hw1bWEP3CNP3B6e7uqMrnT05
         IScXOj6fa4XGlecDZuXJSUlR7tAHW8l5RfTzV3PXSC9oUlbrX4zBzmaqbIcDPGNiFs
         czZNUhqWn7/2WMS8+Y1z7fEAPFuLRp/ZcoRxBrvg=
Date:   Sat, 08 May 2021 15:53:24 -0700
From:   akpm@linux-foundation.org
To:     konishi.ryusuke@gmail.com, liu.xuzhi@zte.com.cn,
        mm-commits@vger.kernel.org
Subject:  [merged]
 fs-nilfs2-fix-misspellings-using-codespell-tool.patch removed from -mm tree
Message-ID: <20210508225324.Yemi78BxR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nilfs2: fix misspellings using codespell tool
has been removed from the -mm tree.  Its filename was
     fs-nilfs2-fix-misspellings-using-codespell-tool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


