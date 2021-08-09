Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307A1C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 19:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05AD061052
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 19:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhHITPD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 15:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235895AbhHITPC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 15:15:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A91D8606A5;
        Mon,  9 Aug 2021 19:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628536481;
        bh=cd3SFioF0Czo/i8ITYcDA+z1lYdh6hkI/Vl4zG48MAU=;
        h=Date:From:To:Subject:From;
        b=jItA0vnxmk27eIe/uLOscpvmupIg/JWCdhFBsS10dq1FWLbosw7w8OIjWuOgYjC0Y
         xCYdyzLwX+BX/aPsPC9huDKLgWr1SK1FQkGVs6aDmXqAqn+clQOqFPNJMf+S6bVIqn
         yIbenY/Akht792Rc2oYTAy4zJc6eENnmMcOiMZUc=
Date:   Mon, 09 Aug 2021 12:14:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + mm-migrate-correct-kernel-doc-notation.patch added to -mm
 tree
Message-ID: <20210809191441.EsHxu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: correct kernel-doc notation
has been added to the -mm tree.  Its filename is
     mm-migrate-correct-kernel-doc-notation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-correct-kernel-doc-notation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-correct-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/migrate: correct kernel-doc notation

Use the expected "Return:" format to prevent a kernel-doc warning.

mm/migrate.c:1157: warning: Excess function parameter 'returns' description in 'next_demotion_node'

Link: https://lkml.kernel.org/r/20210808203151.10632-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-correct-kernel-doc-notation
+++ a/mm/migrate.c
@@ -1149,7 +1149,7 @@ static int node_demotion[MAX_NUMNODES] _
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
  *
- * @returns: node id for next memory node in the demotion path hierarchy
+ * Return: node id for next memory node in the demotion path hierarchy
  * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
  * @node online or guarantee that it *continues* to be the next demotion
  * target.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-migrate-correct-kernel-doc-notation.patch
alpha-agp-make-empty-macros-use-do-while-0-style.patch
lib-dump_stack-correct-kernel-doc-notation.patch
lib-iov_iterc-fix-kernel-doc-warnings.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
mm-workingset-correct-kernel-doc-notations.patch
scripts-check_extable-fix-typo-in-user-error-message.patch

