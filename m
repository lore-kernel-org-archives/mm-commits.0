From: akpm@linux-foundation.org
Subject: + zsmalloc-make-zsmalloc-module-buildable.patch added to -mm tree
Date: Thu, 15 May 2014 16:10:45 -0700
Message-ID: <53754975./NlF7/ukyo5k/3Oq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaEOXKq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 19:10:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: + zsmalloc-make-zsmalloc-module-buildable.patch added to -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 16:10:45 -0700


The patch titled
     Subject: mm/zsmalloc: make zsmalloc module-buildable
has been added to the -mm tree.  Its filename is
     zsmalloc-make-zsmalloc-module-buildable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-make-zsmalloc-module-buildable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-make-zsmalloc-module-buildable.patch

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
Subject: mm/zsmalloc: make zsmalloc module-buildable

Now, we can build zsmalloc as module because unmap_kernel_range was
exported.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~zsmalloc-make-zsmalloc-module-buildable mm/Kconfig
--- a/mm/Kconfig~zsmalloc-make-zsmalloc-module-buildable
+++ a/mm/Kconfig
@@ -555,7 +555,7 @@ config MEM_SOFT_DIRTY
 	  See Documentation/vm/soft-dirty.txt for more details.
 
 config ZSMALLOC
-	bool "Memory allocator for compressed pages"
+	tristate "Memory allocator for compressed pages"
 	depends on MMU
 	default n
 	help
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
zram-correct-offset-usage-in-zram_bio_discard.patch
zsmalloc-fixup-trivial-zs-size-classes-value-in-comments.patch
mm-export-unmap_kernel_range.patch
zsmalloc-make-zsmalloc-module-buildable.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

