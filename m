Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1A8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9667161AA3
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhKRWbH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230133AbhKRWbH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 17:31:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB3A261139;
        Thu, 18 Nov 2021 22:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637274486;
        bh=0BMcxP3Om+x7Tdfvbw1OVSHYHTJDohfyPHZUXhZiGts=;
        h=Date:From:To:Subject:From;
        b=2mTTvOW1UIp10sAWMDErAYbdgUskZJpUgNnOAI7meaw2e42L0R0c+GHahWmCy6mq+
         7pnJkPQYwUjGtHU4PzN47sMxMth/M5CSqbnsV0rX43i6vBZN+KZ1yAJebFOYNNNfgO
         ZCz+pQUdND21UF69wuAaMcgTcLs/axnrqtJWh7Qc=
Date:   Thu, 18 Nov 2021 14:28:06 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangborong@cdjrlc.com
Subject:  + ia64-fix-typo-in-a-comment.patch added to -mm tree
Message-ID: <20211118222806.a6zRsyaW4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: fix typo in a comment
has been added to the -mm tree.  Its filename is
     ia64-fix-typo-in-a-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-fix-typo-in-a-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-fix-typo-in-a-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Wang <wangborong@cdjrlc.com>
Subject: ia64: fix typo in a comment

The double `the' in a comment is repeated, thus it should be removed.

Link: https://lkml.kernel.org/r/20211113030316.22650-1-wangborong@cdjrlc.com
Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/uncached.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/uncached.c~ia64-fix-typo-in-a-comment
+++ a/arch/ia64/kernel/uncached.c
@@ -171,7 +171,7 @@ failed:
  * @n_pages: number of contiguous pages to allocate
  *
  * Allocate the specified number of contiguous uncached pages on the
- * the requested node. If not enough contiguous uncached pages are available
+ * requested node. If not enough contiguous uncached pages are available
  * on the requested node, roundrobin starting with the next higher node.
  */
 unsigned long uncached_alloc_page(int starting_nid, int n_pages)
_

Patches currently in -mm which might be from wangborong@cdjrlc.com are

ia64-fix-typo-in-a-comment.patch

