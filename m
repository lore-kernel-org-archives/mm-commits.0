From: akpm@linux-foundation.org
Subject: + fix-documentation-filesystems-ramfs-rootfs-initramfstxt.patch added to -mm tree
Date: Thu, 21 Aug 2008 12:41:02 -0700
Message-ID: <200808211941.m7LJf2Fv022396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760959AbYHUTlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 15:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fransmeulenbroeks@gmail.com, rob@landley.net


The patch titled
     Fix Documentation/filesystems/ramfs-rootfs-initramfs.txt
has been added to the -mm tree.  Its filename is
     fix-documentation-filesystems-ramfs-rootfs-initramfstxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-documentation-filesystems-ramfs-rootfs-initramfstxt.patch
linux-next.patch

