From: akpm@linux-foundation.org
Subject: + mm-fix-build-warnings-in-linux-compactionh-fix.patch added to
 -mm tree
Date: Thu, 16 Jun 2016 14:54:54 -0700
Message-ID: <5763202e.sZKjuvCk2Kk6n1HQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbcFPVyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 17:54:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-build-warnings-in-linux-compactionh-fix
has been added to the -mm tree.  Its filename is
     mm-fix-build-warnings-in-linux-compactionh-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-build-warnings-in-linux-compactionh-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-build-warnings-in-linux-compactionh-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

