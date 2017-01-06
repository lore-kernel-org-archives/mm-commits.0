From: akpm@linux-foundation.org
Subject: + mm-fix-typo-of-cache_alloc_zspage.patch added to -mm tree
Date: Thu, 05 Jan 2017 16:51:47 -0800
Message-ID: <586eea23.T5Fz3ab4ZPdpAJCM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdAFAvI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:51:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typo ni cache_alloc_zspage()
has been added to the -mm tree.  Its filename is
     mm-fix-typo-of-cache_alloc_zspage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-typo-of-cache_alloc_zspage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-typo-of-cache_alloc_zspage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: fix typo ni cache_alloc_zspage()

Delete extra semicolon, it was introduced in 3783689 ("zsmalloc: introduce
zspage structure").

Link: http://lkml.kernel.org/r/5864C12F.60709@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-fix-typo-of-cache_alloc_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-fix-typo-of-cache_alloc_zspage
+++ a/mm/zsmalloc.c
@@ -364,7 +364,7 @@ static struct zspage *cache_alloc_zspage
 {
 	return kmem_cache_alloc(pool->zspage_cachep,
 			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
-};
+}
 
 static void cache_free_zspage(struct zs_pool *pool, struct zspage *zspage)
 {
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-fix-typo-of-cache_alloc_zspage.patch

