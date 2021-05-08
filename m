Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68642C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3683861421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWvY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhEHWvX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8985C6100C;
        Sat,  8 May 2021 22:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514221;
        bh=lPkC3O/H14F+ZkuNxQrPqwJRxLMrUoyQWs9cxvzw0n4=;
        h=Date:From:To:Subject:From;
        b=HdCHEXvPD9xMqoMLuLJ+vU1mHm3Dr5CS+tIs5uBW9C1LKwfVIthQlno75hhoSZWSo
         0RXBphVzIA5XJvs/qlJsUt6+z49yxibFSpki9aJEm+y0MwZDqbfu3nmYMBixRvjMkA
         N7z0Lv+ct9xeIRuB8jlKmlk+MAjqV71qeO0ff67w=
Date:   Sat, 08 May 2021 15:50:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com, willy@infradead.org
Subject:  [merged] mm-typo-fix-in-the-file-utilc.patch removed from
 -mm tree
Message-ID: <20210508225021.RGjQDcFJY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util.c: fix typo
has been removed from the -mm tree.  Its filename was
     mm-typo-fix-in-the-file-utilc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: mm/util.c: fix typo

s/condtion/condition/

Link: https://lkml.kernel.org/r/20210317033439.3429411-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-typo-fix-in-the-file-utilc
+++ a/mm/util.c
@@ -765,7 +765,7 @@ int overcommit_policy_handler(struct ctl
 	 * The deviation of sync_overcommit_as could be big with loose policy
 	 * like OVERCOMMIT_ALWAYS/OVERCOMMIT_GUESS. When changing policy to
 	 * strict OVERCOMMIT_NEVER, we need to reduce the deviation to comply
-	 * with the strict "NEVER", and to avoid possible race condtion (even
+	 * with the strict "NEVER", and to avoid possible race condition (even
 	 * though user usually won't too frequently do the switching to policy
 	 * OVERCOMMIT_NEVER), the switch is done in the following order:
 	 *	1. changing the batch
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are


