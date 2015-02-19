From: akpm@linux-foundation.org
Subject: + fs-fat-remove-unnecessary-includes-fix.patch added to -mm tree
Date: Wed, 18 Feb 2015 16:06:43 -0800
Message-ID: <54e52913.XKuRgKFPBd6R8/U6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbBSAGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 19:06:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp, kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-fat-remove-unnecessary-includes-fix
has been added to the -mm tree.  Its filename is
     fs-fat-remove-unnecessary-includes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fat-remove-unnecessary-includes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-remove-unnecessary-includes-fix.patch

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
Subject: fs-fat-remove-unnecessary-includes-fix

fs/fat/iode.c needs seq_file.h

Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fat/inode.c~fs-fat-remove-unnecessary-includes-fix fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-remove-unnecessary-includes-fix
+++ a/fs/fat/inode.c
@@ -15,6 +15,7 @@
 #include <linux/mpage.h>
 #include <linux/aio.h>
 #include <linux/vfs.h>
+#include <linux/seq_file.h>
 #include <linux/parser.h>
 #include <linux/blkdev.h>
 #include <asm/unaligned.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-fixup.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

