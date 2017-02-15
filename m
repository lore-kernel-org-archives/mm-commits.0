From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-fix-comment-in-zsmalloc.patch added to -mm tree
Date: Wed, 15 Feb 2017 13:22:18 -0800
Message-ID: <58a4c68a.WjpkknoYClhi1CHT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbdBOVWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 16:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, guohanjun@huawei.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: fix comment in zsmalloc
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-fix-comment-in-zsmalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-fix-comment-in-zsmalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-fix-comment-in-zsmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-migration-make-isolate_movable_page-return-int-type.patch
mm-migration-make-isolate_movable_page-return-int-type-v6.patch
mm-migration-make-isolate_movable_page-always-defined.patch
hwpoison-soft-offlining-for-non-lru-movable-page.patch
mm-hotplug-enable-memory-hotplug-for-non-lru-movable-pages.patch
mm-zsmalloc-remove-redundant-setpageprivate2-in-create_page_chain.patch
mm-zsmalloc-fix-comment-in-zsmalloc.patch
mm-balloon-umount-balloon_mnt-when-remove-vb-device.patch

