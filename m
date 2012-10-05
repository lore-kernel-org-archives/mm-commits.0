From: akpm@linux-foundation.org
Subject: [merged] score-select-generic-atomic64_t-support.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:48 -0700
Message-ID: <20121005201349.176F85C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:46435 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793Ab2JEUNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:51 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so138343fae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, lennox.wu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: select generic atomic64_t support
has been removed from the -mm tree.  Its filename was
     score-select-generic-atomic64_t-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: score: select generic atomic64_t support

It's required for the core fs/namespace.c and many other basic features.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/score/Kconfig~score-select-generic-atomic64_t-support arch/score/Kconfig
--- a/arch/score/Kconfig~score-select-generic-atomic64_t-support
+++ a/arch/score/Kconfig
@@ -5,6 +5,7 @@ config SCORE
        select HAVE_GENERIC_HARDIRQS
        select GENERIC_IRQ_SHOW
        select GENERIC_IOMAP
+       select GENERIC_ATOMIC64
        select HAVE_MEMBLOCK
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
h8300-select-generic-atomic64_t-support.patch
readahead-fault-retry-breaks-mmap-file-read-random-detection.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
rbtree-performance-and-correctness-test-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch
mm-compaction-restart-compaction-from-near-where-it-left-off-fix.patch
fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode.patch
kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch

