From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-mm.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:49 -0700
Message-ID: <200710162030.l9GKUnqA014438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966187AbXJPVqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in mm/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in mm/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	mm/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 --
 mm/shmem.c     |    1 -
 mm/swap.c      |    2 --
 3 files changed, 5 deletions(-)

diff -puN mm/mempolicy.c~clean-up-duplicate-includes-in-mm mm/mempolicy.c
--- a/mm/mempolicy.c~clean-up-duplicate-includes-in-mm
+++ a/mm/mempolicy.c
@@ -72,7 +72,6 @@
 #include <linux/hugetlb.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/mm.h>
 #include <linux/nodemask.h>
 #include <linux/cpuset.h>
 #include <linux/gfp.h>
@@ -82,7 +81,6 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/compat.h>
-#include <linux/mempolicy.h>
 #include <linux/swap.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
diff -puN mm/shmem.c~clean-up-duplicate-includes-in-mm mm/shmem.c
--- a/mm/shmem.c~clean-up-duplicate-includes-in-mm
+++ a/mm/shmem.c
@@ -49,7 +49,6 @@
 #include <linux/ctype.h>
 #include <linux/migrate.h>
 #include <linux/highmem.h>
-#include <linux/backing-dev.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
diff -puN mm/swap.c~clean-up-duplicate-includes-in-mm mm/swap.c
--- a/mm/swap.c~clean-up-duplicate-includes-in-mm
+++ a/mm/swap.c
@@ -24,12 +24,10 @@
 #include <linux/module.h>
 #include <linux/mm_inline.h>
 #include <linux/buffer_head.h>	/* for try_to_release_page() */
-#include <linux/module.h>
 #include <linux/percpu_counter.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
-#include <linux/init.h>
 
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-xfs.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
