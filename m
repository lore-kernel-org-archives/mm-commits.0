From: akpm@linux-foundation.org
Subject: + mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
 added to -mm tree
Date: Thu, 09 Jun 2016 15:29:25 -0700
Message-ID: <5759edc5.gHEav8LupB8IriNw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbcFIW30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2016 18:29:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, gi-oh.kim@profitbricks.com, koct9i@gmail.com, minchan@kernel.org, rdunlap@infradead.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-balloon-use-general-non-lru-movable-page-feature-fix
has been added to the -mm tree.  Its filename is
     mm-balloon-use-general-non-lru-movable-page-feature-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon-use-general-non-lru-movable-page-feature-fix.patch

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

revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

