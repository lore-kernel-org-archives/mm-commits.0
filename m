From: akpm@linux-foundation.org
Subject: [merged] tigran-has-moved.patch removed from -mm tree
Date: Tue, 16 May 2017 10:50:03 -0700
Message-ID: <20170516175003.GHQLNl4f8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752639AbdEPRuJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 13:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aivazian.tigran@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Tigran has moved
has been removed from the -mm tree.  Its filename was
     tigran-has-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2483,7 +2483,7 @@ S:	Maintained
 F:	drivers/net/ethernet/ec_bhf.c
 
 BFS FILE SYSTEM
-M:	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
+M:	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>
 S:	Maintained
 F:	Documentation/filesystems/bfs.txt
 F:	fs/bfs/
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
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

