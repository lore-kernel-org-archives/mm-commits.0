From: akpm@linux-foundation.org
Subject: - m68k-dont-include-asm-m68k-pageh-in-asm-m68k-userh.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:03 -0800
Message-ID: <200702112248.l1BMm3fc015593@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652AbXBKWsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: don't include asm-m68k/page.h in asm-m68k/user.h
has been removed from the -mm tree.  Its filename was
     m68k-dont-include-asm-m68k-pageh-in-asm-m68k-userh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: don't include asm-m68k/page.h in asm-m68k/user.h
From: Mike Frysinger <vapier@gentoo.org>

We don't actually use anything from asm-m68k/page.h in asm-m68k/user.h, so
don't bother including it

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/user.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/asm-m68k/user.h~m68k-dont-include-asm-m68k-pageh-in-asm-m68k-userh include/asm-m68k/user.h
--- a/include/asm-m68k/user.h~m68k-dont-include-asm-m68k-pageh-in-asm-m68k-userh
+++ a/include/asm-m68k/user.h
@@ -1,8 +1,6 @@
 #ifndef _M68K_USER_H
 #define _M68K_USER_H
 
-#include <asm/page.h>
-
 /* Core file format: The core file is written in such a way that gdb
    can understand it and provide useful information to the user (under
    linux we use the 'trad-core' bfd).  There are quite a number of
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
search-a-little-harder-for-mkimage.patch
new-toplevel-target-headers_check_all.patch
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
export-ufs_fsh-to-userspace.patch
