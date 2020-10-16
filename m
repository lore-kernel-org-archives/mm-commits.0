Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3211BC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D71112145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881587;
	bh=sU74t6SB9fBdB/WA4+OXqlFeuUpDd89b04+97/YKuUY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=OT1VE/hZWYfzSJcnSj6hym4rZ9G3CMx/srgTbWvKzpPTEgPOKZeLTWMBWVAgnyS9v
	 XPco7K896+J8yKZZ5FMsmYSPveYgQVPESCz+sEi1HtNJ2ijmxQgO3PpSxAPW75UOdj
	 wBxuXAiaQjXlQQ2Wqa3gb1MjoUNzPGNp6KLV1IkY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409103AbgJPUxH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393599AbgJPUxH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:07 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94634205CB;
        Fri, 16 Oct 2020 20:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881586;
        bh=sU74t6SB9fBdB/WA4+OXqlFeuUpDd89b04+97/YKuUY=;
        h=Date:From:To:Subject:From;
        b=NFCPQRRST2RKLxVS4ve8QZtvaWU6fsBkuerIS/uJJUvJm53OL+ZOHUCkHy96GFnBT
         YDmjU4m63tMOaseO1/SWavWzVNz/I2rlOlNudxasaWUNU0ZU6s/lTVbwRF8FgdW6z7
         0V+XNAL2Ft1MNvDsuPO6994qoAE6cwZQPZk1sUFw=
Date:   Fri, 16 Oct 2020 13:53:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] lib-radix-tree-delete-duplicated-words.patch
 removed from -mm tree
Message-ID: <20201016205306.jih9Sv3l8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: radix-tree: delete duplicated words
has been removed from the -mm tree.  Its filename was
     lib-radix-tree-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: radix-tree: delete duplicated words

Drop the repeated word "be".

Link: https://lkml.kernel.org/r/20200823040508.26086-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/radix-tree.c~lib-radix-tree-delete-duplicated-words
+++ a/lib/radix-tree.c
@@ -325,7 +325,7 @@ static __must_check int __radix_tree_pre
 	int ret = -ENOMEM;
 
 	/*
-	 * Nodes preloaded by one cgroup can be be used by another cgroup, so
+	 * Nodes preloaded by one cgroup can be used by another cgroup, so
 	 * they should never be accounted to any particular memory cgroup.
 	 */
 	gfp_mask &= ~__GFP_ACCOUNT;
_

Patches currently in -mm which might be from rdunlap@infradead.org are


