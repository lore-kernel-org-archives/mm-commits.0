From: akpm@linux-foundation.org
Subject: [merged] mm-includecheck-fix-for-mm-shmemc.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:27 -0700
Message-ID: <200909222041.n8MKfR4U007593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837AbZIVUmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, hugh.dickins@tiscali.co.uk, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: includecheck fix for mm/shmem.c
has been removed from the -mm tree.  Its filename was
     mm-includecheck-fix-for-mm-shmemc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: includecheck fix for mm/shmem.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following 'make includecheck' warning:

  mm/shmem.c: linux/vfs.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/shmem.c~mm-includecheck-fix-for-mm-shmemc mm/shmem.c
--- a/mm/shmem.c~mm-includecheck-fix-for-mm-shmemc
+++ a/mm/shmem.c
@@ -49,7 +49,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/backing-dev.h>
 #include <linux/shmem_fs.h>
 #include <linux/writeback.h>
-#include <linux/vfs.h>
 #include <linux/blkdev.h>
 #include <linux/security.h>
 #include <linux/swapops.h>
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch
includecheck-fix-documentation-cfag12864b-examplec.patch

