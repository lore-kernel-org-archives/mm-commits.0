From: akpm@linux-foundation.org
Subject: + mm-includecheck-fix-for-mm-shmemc.patch added to -mm tree
Date: Mon, 10 Aug 2009 23:47:48 -0700
Message-ID: <200908110647.n7B6lmuO025551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbZHKLyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, hugh.dickins@tiscali.co.uk, jaswinderrajput@gmail.com


The patch titled
     mm: includecheck fix for mm/shmem.c
has been added to the -mm tree.  Its filename is
     mm-includecheck-fix-for-mm-shmemc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
mm-includecheck-fix-for-mm-shmemc.patch
mm-includecheck-fix-for-mm-nommuc.patch
mn10300-includecheck-fix-mn10300-pcih.patch

