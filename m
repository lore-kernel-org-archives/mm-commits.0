From: akpm@osdl.org
Subject: + update-tigrans-email-addresses.patch added to -mm tree
Date: Tue, 12 Dec 2006 13:16:38 -0800
Message-ID: <200612122116.kBCLGcsY015995@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42484 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbWLLVQv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 16:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tigran@aivazian.fsnet.co.uk


The patch titled
     update Tigran's email addresses
has been added to the -mm tree.  Its filename is
     update-tigrans-email-addresses.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update Tigran's email addresses
From: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>

As Adrian pointed out recently, there were still a couple of places where
I should have fixed my email address.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/bfs.txt |    2 +-
 arch/i386/kernel/microcode.c      |    6 +++---
 fs/bfs/inode.c                    |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/filesystems/bfs.txt~update-tigrans-email-addresses Documentation/filesystems/bfs.txt
--- a/Documentation/filesystems/bfs.txt~update-tigrans-email-addresses
+++ a/Documentation/filesystems/bfs.txt
@@ -54,4 +54,4 @@ The first 4 bytes should be 0x1badface.
 If you have any patches, questions or suggestions regarding this BFS
 implementation please contact the author:
 
-Tigran A. Aivazian <tigran@veritas.com>
+Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
diff -puN arch/i386/kernel/microcode.c~update-tigrans-email-addresses arch/i386/kernel/microcode.c
--- a/arch/i386/kernel/microcode.c~update-tigrans-email-addresses
+++ a/arch/i386/kernel/microcode.c
@@ -1,7 +1,7 @@
 /*
  *	Intel CPU Microcode Update Driver for Linux
  *
- *	Copyright (C) 2000-2004 Tigran Aivazian
+ *	Copyright (C) 2000-2006 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
  *		      2006	Shaohua Li <shaohua.li@intel.com>
  *
  *	This driver allows to upgrade microcode on Intel processors
@@ -92,7 +92,7 @@
 #include <asm/processor.h>
 
 MODULE_DESCRIPTION("Intel CPU (IA-32) Microcode Update Driver");
-MODULE_AUTHOR("Tigran Aivazian <tigran@veritas.com>");
+MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_LICENSE("GPL");
 
 #define MICROCODE_VERSION 	"1.14a"
@@ -752,7 +752,7 @@ static int __init microcode_init (void)
 	register_hotcpu_notifier(&mc_cpu_notifier);
 
 	printk(KERN_INFO 
-		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@veritas.com>\n");
+		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
 	return 0;
 }
 
diff -puN fs/bfs/inode.c~update-tigrans-email-addresses fs/bfs/inode.c
--- a/fs/bfs/inode.c~update-tigrans-email-addresses
+++ a/fs/bfs/inode.c
@@ -1,7 +1,7 @@
 /*
  *	fs/bfs/inode.c
  *	BFS superblock and inode operations.
- *	Copyright (C) 1999,2000 Tigran Aivazian <tigran@veritas.com>
+ *	Copyright (C) 1999-2006 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
  *	From fs/minix, Copyright (C) 1991, 1992 Linus Torvalds.
  *
  *      Made endianness-clean by Andrew Stribblehill <ads@wompom.org>, 2005.
@@ -18,7 +18,7 @@
 #include <asm/uaccess.h>
 #include "bfs.h"
 
-MODULE_AUTHOR("Tigran A. Aivazian <tigran@veritas.com>");
+MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_DESCRIPTION("SCO UnixWare BFS filesystem for Linux");
 MODULE_LICENSE("GPL");
 
_

Patches currently in -mm which might be from tigran@aivazian.fsnet.co.uk are

update-tigrans-email-addresses.patch

