From: akpm@linux-foundation.org
Subject: [folded-merged] fs-fat-remove-unnecessary-includes-fix.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 12:08:04 -0700
Message-ID: <55300894.bUXMhytgl+n04Vez%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbbDPTIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp, kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-fat-remove-unnecessary-includes-fix
has been removed from the -mm tree.  Its filename was
     fs-fat-remove-unnecessary-includes-fix.patch

This patch was dropped because it was folded into fs-fat-remove-unnecessary-includes.patch

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
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/vfs.h>
+#include <linux/seq_file.h>
 #include <linux/parser.h>
 #include <linux/blkdev.h>
 #include <asm/unaligned.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions.patch
binfmt_misc-simplify-entry_status.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch
fs-fat-remove-unnecessary-includes.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch

