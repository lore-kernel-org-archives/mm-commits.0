From: akpm@linux-foundation.org
Subject: [merged] unicore32-select-generic-atomic64_t-support.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:02 -0700
Message-ID: <20121005201202.AC5E21E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53975 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab2JEUMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:03 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so235722ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: unicore32: select generic atomic64_t support
has been removed from the -mm tree.  Its filename was
     unicore32-select-generic-atomic64_t-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: unicore32: select generic atomic64_t support

It's required for the core fs/namespace.c and many other basic features.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/unicore32/Kconfig~unicore32-select-generic-atomic64_t-support arch/unicore32/Kconfig
--- a/arch/unicore32/Kconfig~unicore32-select-generic-atomic64_t-support
+++ a/arch/unicore32/Kconfig
@@ -6,6 +6,7 @@ config UNICORE32
 	select HAVE_DMA_ATTRS
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
+	select GENERIC_ATOMIC64
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
 	select ARCH_HAVE_CUSTOM_GPIO_H
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

