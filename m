From: akpm@linux-foundation.org
Subject: + tigran-has-moved.patch added to -mm tree
Date: Wed, 10 May 2017 13:32:57 -0700
Message-ID: <591378f9.tebUG6o9YHBx1V2d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752912AbdEJUc6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 16:32:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aivazian.tigran@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Tigran has moved
has been added to the -mm tree.  Its filename is
     tigran-has-moved.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tigran-has-moved.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tigran-has-moved.patch

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
Subject: Tigran has moved

Cc: Tigran Aivazian <aivazian.tigran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/bfs.txt     |    2 +-
 MAINTAINERS                           |    2 +-
 arch/x86/kernel/cpu/microcode/amd.c   |    2 +-
 arch/x86/kernel/cpu/microcode/core.c  |    2 +-
 arch/x86/kernel/cpu/microcode/intel.c |    2 +-
 fs/bfs/inode.c                        |    4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/bfs/inode.c~tigran-has-moved fs/bfs/inode.c
--- a/fs/bfs/inode.c~tigran-has-moved
+++ a/fs/bfs/inode.c
@@ -1,7 +1,7 @@
 /*
  *	fs/bfs/inode.c
  *	BFS superblock and inode operations.
- *	Copyright (C) 1999-2006 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
+ *	Copyright (C) 1999-2006 Tigran Aivazian <aivazian.tigran@gmail.com>
  *	From fs/minix, Copyright (C) 1991, 1992 Linus Torvalds.
  *
  *      Made endianness-clean by Andrew Stribblehill <ads@wompom.org>, 2005.
@@ -19,7 +19,7 @@
 #include <linux/uaccess.h>
 #include "bfs.h"
 
-MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
+MODULE_AUTHOR("Tigran Aivazian <aivazian.tigran@gmail.com>");
 MODULE_DESCRIPTION("SCO UnixWare BFS filesystem for Linux");
 MODULE_LICENSE("GPL");
 
diff -puN Documentation/filesystems/bfs.txt~tigran-has-moved Documentation/filesystems/bfs.txt
--- a/Documentation/filesystems/bfs.txt~tigran-has-moved
+++ a/Documentation/filesystems/bfs.txt
@@ -54,4 +54,4 @@ The first 4 bytes should be 0x1badface.
 If you have any patches, questions or suggestions regarding this BFS
 implementation please contact the author:
 
-Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
+Tigran Aivazian <aivazian.tigran@gmail.com>
diff -puN MAINTAINERS~tigran-has-moved MAINTAINERS
--- a/MAINTAINERS~tigran-has-moved
+++ a/MAINTAINERS
@@ -2473,7 +2473,7 @@ S:	Maintained
 F:	drivers/net/ethernet/ec_bhf.c
 
 BFS FILE SYSTEM
-M:	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
+M:	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>
 S:	Maintained
 F:	Documentation/filesystems/bfs.txt
 F:	fs/bfs/
diff -puN arch/x86/kernel/cpu/microcode/intel.c~tigran-has-moved arch/x86/kernel/cpu/microcode/intel.c
--- a/arch/x86/kernel/cpu/microcode/intel.c~tigran-has-moved
+++ a/arch/x86/kernel/cpu/microcode/intel.c
@@ -1,7 +1,7 @@
 /*
  * Intel CPU Microcode Update Driver for Linux
  *
- * Copyright (C) 2000-2006 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
+ * Copyright (C) 2000-2006 Tigran Aivazian <aivazian.tigran@gmail.com>
  *		 2006 Shaohua Li <shaohua.li@intel.com>
  *
  * Intel CPU microcode early update for Linux
diff -puN arch/x86/kernel/cpu/microcode/core.c~tigran-has-moved arch/x86/kernel/cpu/microcode/core.c
--- a/arch/x86/kernel/cpu/microcode/core.c~tigran-has-moved
+++ a/arch/x86/kernel/cpu/microcode/core.c
@@ -1,7 +1,7 @@
 /*
  * CPU Microcode Update Driver for Linux
  *
- * Copyright (C) 2000-2006 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
+ * Copyright (C) 2000-2006 Tigran Aivazian <aivazian.tigran@gmail.com>
  *	      2006	Shaohua Li <shaohua.li@intel.com>
  *	      2013-2016	Borislav Petkov <bp@alien8.de>
  *
diff -puN arch/x86/kernel/cpu/microcode/amd.c~tigran-has-moved arch/x86/kernel/cpu/microcode/amd.c
--- a/arch/x86/kernel/cpu/microcode/amd.c~tigran-has-moved
+++ a/arch/x86/kernel/cpu/microcode/amd.c
@@ -10,7 +10,7 @@
  *  Author: Peter Oruba <peter.oruba@amd.com>
  *
  *  Based on work by:
- *  Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
+ *  Tigran Aivazian <aivazian.tigran@gmail.com>
  *
  *  early loader:
  *  Copyright (C) 2013 Advanced Micro Devices, Inc.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
gcov-support-gcc-71-v2-checkpatch-fixes.patch
mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch
tigran-has-moved.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

