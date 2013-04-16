From: akpm@linux-foundation.org
Subject: + memblock-fix-missing-comment-of-memblock_insert_region.patch added to -mm tree
Date: Tue, 16 Apr 2013 14:17:02 -0700
Message-ID: <20130416211702.95DA15A422E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:64827 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965219Ab3DPVRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 17:17:04 -0400
Received: by mail-vc0-f202.google.com with SMTP id m16so95893vca.3
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 14:17:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com


The patch titled
     Subject: memblock: fix missing comment of memblock_insert_region()
has been added to the -mm tree.  Its filename is
     memblock-fix-missing-comment-of-memblock_insert_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch
mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled.patch
firmware-memmap-fix-firmware_map_entry-leak.patch
mm-remove-unused-parameter-of-pages_correctly_reserved.patch
memblock-fix-missing-comment-of-memblock_insert_region.patch

