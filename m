From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-build-warnings-in-linux-compactionh-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2016 15:05:47 -0700
Message-ID: <5797debb.jVzQbjpC7MHUlQQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161275AbcGZWFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-build-warnings-in-linux-compactionh-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-build-warnings-in-linux-compactionh-fix.patch

This patch was dropped because it was folded into mm-fix-build-warnings-in-linux-compactionh.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-build-warnings-in-linux-compactionh-fix

revert mm-balloon-use-general-non-lru-movable-page-feature-fix.patch temp
fix

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/balloon_compaction.h~mm-fix-build-warnings-in-linux-compactionh-fix include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-fix-build-warnings-in-linux-compactionh-fix
+++ a/include/linux/balloon_compaction.h
@@ -45,7 +45,6 @@
 #define _LINUX_BALLOON_COMPACTION_H
 #include <linux/pagemap.h>
 #include <linux/page-flags.h>
-#include <linux/node.h>
 #include <linux/migrate.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh.patch

