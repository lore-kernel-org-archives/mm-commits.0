From: akpm@linux-foundation.org
Subject: + mm-vmalloc-update-the-header-about-kva-rework.patch added
 to -mm tree
Date: Wed, 24 Jun 2020 15:31:15 -0700
Message-ID: <20200624223115.rUCvf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388453AbgFXWbQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:31:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, urezki@gmail.com


The patch titled
     Subject: mm/vmalloc: update the header about KVA rework
has been added to the -mm tree.  Its filename is
     mm-vmalloc-update-the-header-about-kva-rework.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-update-the-header-about-kva-rework.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-update-the-header-about-kva-rework.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: update the header about KVA rework

Reflect information about the author, date and year when the KVA rework
was done.

Link: http://lkml.kernel.org/r/20200622195821.4796-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-update-the-header-about-kva-rework
+++ a/mm/vmalloc.c
@@ -7,6 +7,7 @@
  *  SMP-safe vmalloc/vfree/ioremap, Tigran Aivazian <tigran@veritas.com>, May 2000
  *  Major rework to support vmap/vunmap, Christoph Hellwig, SGI, August 2002
  *  Numa awareness, Christoph Lameter, SGI, June 2005
+ *  Improving global KVA allocator, Uladzislau Rezki, Sony, May 2019
  */
 
 #include <linux/vmalloc.h>
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch
mm-vmalloc-simplify-augment_tree_propagate_check-func.patch
mm-vmalloc-switch-to-propagate-callback.patch
mm-vmalloc-update-the-header-about-kva-rework.patch
