From: akpm@linux-foundation.org
Subject: [merged] m68k-convert-to-asm-generic-hardirqh.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:44:37 -0700
Message-ID: <200909222044.n8MKibWL013988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175AbZIVUoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: convert to asm-generic/hardirq.h
has been removed from the -mm tree.  Its filename was
     m68k-convert-to-asm-generic-hardirqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/hardirq_mm.h |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN arch/m68k/include/asm/hardirq_mm.h~m68k-convert-to-asm-generic-hardirqh arch/m68k/include/asm/hardirq_mm.h
--- a/arch/m68k/include/asm/hardirq_mm.h~m68k-convert-to-asm-generic-hardirqh
+++ a/arch/m68k/include/asm/hardirq_mm.h
@@ -1,16 +1,8 @@
 #ifndef __M68K_HARDIRQ_H
 #define __M68K_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/cache.h>
-
-/* entry.S is sensitive to the offsets of these fields */
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
 #define HARDIRQ_BITS	8
 
+#include <asm-generic/hardirq.h>
+
 #endif
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
vfs-seq_file-add-helpers-for-data-filling.patch
libfs-return-error-code-on-failed-attr-set.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
xtensa-convert-to-asm-generic-hardirqh.patch
frv-convert-to-asm-generic-hardirqh.patch
fs-turn-iprune_mutex-into-rwsem.patch
ntfs-remove-ntfs_file_write.patch
qnx4-remove-write-support.patch
fcntl-add-f_etown_ex.patch

