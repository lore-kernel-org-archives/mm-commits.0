From: akpm@linux-foundation.org
Subject: [merged] slab-remove-bad_alien_magic.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:19 -0700
Message-ID: <53e3db87.t1R9XvJyYzSYkS9K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:65388 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGUDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:20 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so843252obc.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: remove BAD_ALIEN_MAGIC
has been removed from the -mm tree.  Its filename was
     slab-remove-bad_alien_magic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: remove BAD_ALIEN_MAGIC

BAD_ALIEN_MAGIC value isn't used anymore. So remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/slab.c~slab-remove-bad_alien_magic mm/slab.c
--- a/mm/slab.c~slab-remove-bad_alien_magic
+++ a/mm/slab.c
@@ -470,8 +470,6 @@ static struct kmem_cache kmem_cache_boot
 	.name = "kmem_cache",
 };
 
-#define BAD_ALIEN_MAGIC 0x01020304ul
