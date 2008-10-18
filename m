From: akpm@linux-foundation.org
Subject: - fix-documentation-filesystems-ramfs-rootfs-initramfstxt.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:20 -0700
Message-ID: <200810182311.m9INBKeQ027712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbYJRXL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fransmeulenbroeks@gmail.com, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Fix Documentation/filesystems/ramfs-rootfs-initramfs.txt
has been removed from the -mm tree.  Its filename was
     fix-documentation-filesystems-ramfs-rootfs-initramfstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix Documentation/filesystems/ramfs-rootfs-initramfs.txt
From: frans <fransmeulenbroeks@gmail.com>

First a file hello.c is created, then the file hello2.c is compiled. 
Change this to hello.c

Signed-off-by: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/ramfs-rootfs-initramfs.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/filesystems/ramfs-rootfs-initramfs.txt~fix-documentation-filesystems-ramfs-rootfs-initramfstxt Documentation/filesystems/ramfs-rootfs-initramfs.txt
--- a/Documentation/filesystems/ramfs-rootfs-initramfs.txt~fix-documentation-filesystems-ramfs-rootfs-initramfstxt
+++ a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -263,7 +263,7 @@ User Mode Linux, like so:
     sleep(999999999);
   }
   EOF
-  gcc -static hello2.c -o init
+  gcc -static hello.c -o init
   echo init | cpio -o -H newc | gzip > test.cpio.gz
   # Testing external initramfs using the initrd loading mechanism.
   qemu -kernel /boot/vmlinuz -initrd test.cpio.gz /dev/zero
_

Patches currently in -mm which might be from fransmeulenbroeks@gmail.com are

origin.patch

