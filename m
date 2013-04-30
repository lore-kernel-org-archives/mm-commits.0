From: akpm@linux-foundation.org
Subject: [merged] memblock-fix-missing-comment-of-memblock_insert_region.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:52 -0700
Message-ID: <20130430184952.7009E5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:62064 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab3D3Stx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:53 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so85458yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: fix missing comment of memblock_insert_region()
has been removed from the -mm tree.  Its filename was
     memblock-fix-missing-comment-of-memblock_insert_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memblock: fix missing comment of memblock_insert_region()

There is no comment for parameter nid of memblock_insert_region().
This patch adds comment for it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/memblock.c~memblock-fix-missing-comment-of-memblock_insert_region mm/memblock.c
--- a/mm/memblock.c~memblock-fix-missing-comment-of-memblock_insert_region
+++ a/mm/memblock.c
@@ -322,10 +322,11 @@ static void __init_memblock memblock_mer
 
 /**
  * memblock_insert_region - insert new memblock region
- * @type: memblock type to insert into
- * @idx: index for the insertion point
- * @base: base address of the new region
- * @size: size of the new region
+ * @type:	memblock type to insert into
+ * @idx:	index for the insertion point
+ * @base:	base address of the new region
+ * @size:	size of the new region
+ * @nid:	node id of the new region
  *
  * Insert new memblock region [@base,@base+@size) into @type at @idx.
  * @type must already have extra room to accomodate the new region.
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

