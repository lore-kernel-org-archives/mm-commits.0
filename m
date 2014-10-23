From: akpm@linux-foundation.org
Subject: + mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
 added to -mm tree
Date: Thu, 23 Oct 2014 12:20:09 -0700
Message-ID: <544954e9./tRkMtGY7Q/Pf3k/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaJWTUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lqymgt@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab/slub: coding style: whitespaces and tabs mixture
has been added to the -mm tree.  Its filename is
     mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: LQYMGT <lqymgt@gmail.com>
Subject: mm: slab/slub: coding style: whitespaces and tabs mixture

Some code in mm/slab.c and mm/slub.c use whitespaces in indent.
Clean them up.

Signed-off-by: LQYMGT <lqymgt@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   10 +++++-----
 mm/slub.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/slab.c~mm-slab-slub-coding-style-whitespaces-and-tabs-mixture mm/slab.c
--- a/mm/slab.c~mm-slab-slub-coding-style-whitespaces-and-tabs-mixture
+++ a/mm/slab.c
@@ -3580,11 +3580,11 @@ static int alloc_kmem_cache_node(struct
 
 	for_each_online_node(node) {
 
-                if (use_alien_caches) {
-                        new_alien = alloc_alien_cache(node, cachep->limit, gfp);
-                        if (!new_alien)
-                                goto fail;
-                }
+		if (use_alien_caches) {
+			new_alien = alloc_alien_cache(node, cachep->limit, gfp);
+			if (!new_alien)
+				goto fail;
+		}
 
 		new_shared = NULL;
 		if (cachep->shared) {
diff -puN mm/slub.c~mm-slab-slub-coding-style-whitespaces-and-tabs-mixture mm/slub.c
--- a/mm/slub.c~mm-slab-slub-coding-style-whitespaces-and-tabs-mixture
+++ a/mm/slub.c
@@ -2554,7 +2554,7 @@ static void __slab_free(struct kmem_cach
 
 			} else { /* Needs to be taken off a list */
 
-	                        n = get_node(s, page_to_nid(page));
+				n = get_node(s, page_to_nid(page));
 				/*
 				 * Speculatively acquire the list_lock.
 				 * If the cmpxchg does not succeed then we may
@@ -2587,10 +2587,10 @@ static void __slab_free(struct kmem_cach
 		 * The list lock was not taken therefore no list
 		 * activity can be necessary.
 		 */
-                if (was_frozen)
-                        stat(s, FREE_FROZEN);
-                return;
-        }
+		if (was_frozen)
+			stat(s, FREE_FROZEN);
+		return;
+	}
 
 	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
 		goto slab_empty;
_

Patches currently in -mm which might be from lqymgt@gmail.com are

mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch

