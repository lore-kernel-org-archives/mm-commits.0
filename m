From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-balloon-use-general-non-lru-movable-page-feature-fix.patch removed from
 -mm tree
Date: Tue, 26 Jul 2016 14:52:41 -0700
Message-ID: <5797dba9.RS7lmQHCCpprhcHN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978AbcGZVwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, gi-oh.kim@profitbricks.com, koct9i@gmail.com, minchan@kernel.org, rdunlap@infradead.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-balloon-use-general-non-lru-movable-page-feature-fix
has been removed from the -mm tree.  Its filename was
     mm-balloon-use-general-non-lru-movable-page-feature-fix.patch

This patch was dropped because it was folded into mm-balloon-use-general-non-lru-movable-page-feature.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-balloon-use-general-non-lru-movable-page-feature-fix

compaction.h requires that the includer first include node.h

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/balloon_compaction.h~mm-balloon-use-general-non-lru-movable-page-feature-fix include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon-use-general-non-lru-movable-page-feature-fix
+++ a/include/linux/balloon_compaction.h
@@ -45,6 +45,7 @@
 #define _LINUX_BALLOON_COMPACTION_H
 #include <linux/pagemap.h>
 #include <linux/page-flags.h>
+#include <linux/node.h>
 #include <linux/compaction.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-balloon-use-general-non-lru-movable-page-feature.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch

