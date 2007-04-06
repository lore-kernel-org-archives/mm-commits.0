From: akpm@linux-foundation.org
Subject: + unused-round_up-name_offset-macro-in-arch-powerpc.patch added to -mm tree
Date: Fri, 06 Apr 2007 15:48:09 -0700
Message-ID: <200704062248.l36Mm9tP021254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36479 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290AbXDFWsL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 18:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com


The patch titled
     Unused ROUND_UP, NAME_OFFSET macro in arch/powerpc
has been added to the -mm tree.  Its filename is
     unused-round_up-name_offset-macro-in-arch-powerpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Unused ROUND_UP, NAME_OFFSET macro in arch/powerpc
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

Unused ROUND_UP, NAME_OFFSET  macro cleanup

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/sys_ppc32.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/powerpc/kernel/sys_ppc32.c~unused-round_up-name_offset-macro-in-arch-powerpc arch/powerpc/kernel/sys_ppc32.c
--- a/arch/powerpc/kernel/sys_ppc32.c~unused-round_up-name_offset-macro-in-arch-powerpc
+++ a/arch/powerpc/kernel/sys_ppc32.c
@@ -53,10 +53,6 @@
 #include <asm/ppc-pci.h>
 #include <asm/syscalls.h>
 
-/* readdir & getdents */
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define ROUND_UP(x) (((x)+sizeof(u32)-1) & ~(sizeof(u32)-1))
-
 struct old_linux_dirent32 {
 	u32		d_ino;
 	u32		d_offset;
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

unused-round_up-name_offset-macro-in-arch-powerpc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
