From: akpm@linux-foundation.org
Subject: [merged] mm-zsmalloc-fix-comment-in-zsmalloc.patch removed from
 -mm tree
Date: Mon, 27 Feb 2017 12:27:55 -0800
Message-ID: <58b48bcb.Gjv+7hiGOsXsyVUc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751924AbdB0U2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, guohanjun@huawei.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: fix comment in zsmalloc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-fix-comment-in-zsmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/zsmalloc: fix comment in zsmalloc

The class index and fullness group are not encoded in (first)page->mapping
any more, after commit 3783689a1aa8 ("zsmalloc: introduce zspage
structure").  Instead, they are store in struct zspage.  Just delete this
unneeded comment.

Link: http://lkml.kernel.org/r/1486620822-36826-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Suggested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-fix-comment-in-zsmalloc mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-fix-comment-in-zsmalloc
+++ a/mm/zsmalloc.c
@@ -267,10 +267,6 @@ struct zs_pool {
 #endif
 };
 
-/*
- * A zspage's class index and fullness group
- * are encoded in its (first)page->mapping
- */
 #define FULLNESS_BITS	2
 #define CLASS_BITS	8
 #define ISOLATED_BITS	3
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are


