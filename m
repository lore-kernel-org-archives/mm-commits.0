From: akpm@linux-foundation.org
Subject: + mm-zswapc-remove-unnecessary-parentheses.patch added to -mm
 tree
Date: Wed, 05 Mar 2014 14:32:21 -0800
Message-ID: <5317a5f5.afTJwofIbaQRyMpG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaCEWcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 17:32:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjennings@variantweb.net, sj38.park@gmail.com

Subject: + mm-zswapc-remove-unnecessary-parentheses.patch added to -mm tree
To: sj38.park@gmail.com,sjennings@variantweb.net
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 14:32:21 -0800


The patch titled
     Subject: mm/zswap.c: remove unnecessary parentheses
has been added to the -mm tree.  Its filename is
     mm-zswapc-remove-unnecessary-parentheses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswapc-remove-unnecessary-parentheses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswapc-remove-unnecessary-parentheses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj38.park@gmail.com>
Subject: mm/zswap.c: remove unnecessary parentheses

Fix following trivial checkpatch error:
	ERROR: return is not a function, parentheses are not required

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Acked-by: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/zswap.c~mm-zswapc-remove-unnecessary-parentheses mm/zswap.c
--- a/mm/zswap.c~mm-zswapc-remove-unnecessary-parentheses
+++ a/mm/zswap.c
@@ -204,7 +204,7 @@ static struct kmem_cache *zswap_entry_ca
 static int zswap_entry_cache_create(void)
 {
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
-	return (zswap_entry_cache == NULL);
+	return zswap_entry_cache == NULL;
 }
 
 static void zswap_entry_cache_destory(void)
@@ -408,8 +408,8 @@ cleanup:
 **********************************/
 static bool zswap_is_full(void)
 {
-	return (totalram_pages * zswap_max_pool_percent / 100 <
-		zswap_pool_pages);
+	return totalram_pages * zswap_max_pool_percent / 100 <
+		zswap_pool_pages;
 }
 
 /*********************************
_

Patches currently in -mm which might be from sj38.park@gmail.com are

mm-zswap-fix-trivial-typo-and-arrange-indentation.patch
mm-zswap-update-zsmalloc-in-comment-to-zbud.patch
mm-zswapc-remove-unnecessary-parentheses.patch
linux-next.patch

