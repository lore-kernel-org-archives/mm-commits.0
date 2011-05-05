From: akpm@linux-foundation.org
Subject: [merged] maintainers-roman-zippel-has-been-mia-for-several-years.patch removed from -mm tree
Date: Thu, 05 May 2011 12:10:03 -0700
Message-ID: <201105051903.p45J3eNC029049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571Ab1EETEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2011 15:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: Roman Zippel has been MIA for several years.
has been removed from the -mm tree.  Its filename was
     maintainers-roman-zippel-has-been-mia-for-several-years.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: Roman Zippel has been MIA for several years.
From: Geert Uytterhoeven <geert@linux-m68k.org>

Hence make AFFS and HFS orphans, and remove him as an m68k maintainer.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~maintainers-roman-zippel-has-been-mia-for-several-years MAINTAINERS
--- a/MAINTAINERS~maintainers-roman-zippel-has-been-mia-for-several-years
+++ a/MAINTAINERS
@@ -405,8 +405,8 @@ S:	Maintained
 F:	sound/oss/aedsp16.c
 
 AFFS FILE SYSTEM
-M:	Roman Zippel <zippel@linux-m68k.org>
-S:	Maintained
+L:	linux-fsdevel@vger.kernel.org
+S:	Orphan
 F:	Documentation/filesystems/affs.txt
 F:	fs/affs/
 
@@ -2961,8 +2961,8 @@ F:	drivers/block/cciss*
 F:	include/linux/cciss_ioctl.h
 
 HFS FILESYSTEM
-M:	Roman Zippel <zippel@linux-m68k.org>
-S:	Maintained
+L:	linux-fsdevel@vger.kernel.org
+S:	Orphan
 F:	Documentation/filesystems/hfs.txt
 F:	fs/hfs/
 
@@ -4016,7 +4016,6 @@ F:	arch/m32r/
 
 M68K ARCHITECTURE
 M:	Geert Uytterhoeven <geert@linux-m68k.org>
-M:	Roman Zippel <zippel@linux-m68k.org>
 L:	linux-m68k@lists.linux-m68k.org
 W:	http://www.linux-m68k.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-nommu-dont-scan-the-vma-list-when-deleting.patch
mm-nommu-find-vma-using-the-sorted-vma-list.patch
mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch
mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch
mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch
arch-add-define-for-each-of-optimized-find-bitops.patch

