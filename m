From: akpm@linux-foundation.org
Subject: + zsmalloc-add-maintainers.patch added to -mm tree
Date: Wed, 08 Jan 2014 15:22:34 -0800
Message-ID: <52cdddba.Q4XzO9XWoZYEG6fE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790AbaAHXWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 18:22:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org

Subject: + zsmalloc-add-maintainers.patch added to -mm tree
To: minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 15:22:34 -0800


The patch titled
     Subject: zsmalloc: add maintainers
has been added to the -mm tree.  Its filename is
     zsmalloc-add-maintainers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-add-maintainers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-add-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: add maintainers

tAdd adds maintainer information for zsmalloc into the MAINTAINERS file.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~zsmalloc-add-maintainers MAINTAINERS
--- a/MAINTAINERS~zsmalloc-add-maintainers
+++ a/MAINTAINERS
@@ -9779,6 +9779,14 @@ M:	"Maciej W. Rozycki" <macro@linux-mips
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
+ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
+M:	Minchan Kim <minchan@kernel.org>
+M:	Nitin Gupta <ngupta@vflare.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/zsmalloc.c
+F:	include/linux/zsmalloc.h
+
 ZSWAP COMPRESSED SWAP CACHING
 M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-bug_on-from-mlock_vma_page.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-zswapc-change-params-from-hidden-to-ro.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch
zram-remove-old-private-project-comment.patch
zram-add-copyright.patch
zsmalloc-add-copyright.patch
zram-add-zram-maintainers.patch
zsmalloc-add-maintainers.patch
debugging-keep-track-of-page-owners.patch

