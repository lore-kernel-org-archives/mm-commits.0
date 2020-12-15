Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E5DC4743A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0918C22D02
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgLOX7K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgLOXW3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:29 -0500
Date:   Tue, 15 Dec 2020 15:20:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074411;
        bh=HUsv4PCDo88X++8U1wPrhR/5I0P7npI92bxANaNjAPs=;
        h=From:To:Subject:From;
        b=GRqnc78p4FggiQ2l29vNnwCmi8pO7/twj+FOch5TA2N8QAQm94xjMj1WJ00A33uwM
         j8VtXT8fkHLOy4e+wF5aboKzKAfL+vw4db3ZP+tDD0GgijhdFDVmD/Tnt99NfsOWe+
         1C5Jz9TZvezw4CBhUxz/s7Un2GIY/aK0YbxRsZAw=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-vmalloc-remove-unnecessary-return-statement.patch removed from -mm tree
Message-ID: <20201215232011.FdSsUgJC2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: remove unnecessary return statement
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-unnecessary-return-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/vmalloc.c: remove unnecessary return statement

Remove unnecessary return statement for void function.

Link: https://lkml.kernel.org/r/ca23f89259c80c3562700ae6e227b2815a195853.1606891153.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-unnecessary-return-statement
+++ a/mm/vmalloc.c
@@ -2291,7 +2291,6 @@ static void __vunmap(const void *addr, i
 	}
 
 	kfree(area);
-	return;
 }
 
 static inline void __vfree_deferred(const void *addr)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


