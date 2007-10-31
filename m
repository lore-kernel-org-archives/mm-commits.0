From: akpm@linux-foundation.org
Subject: + uml-remove-last-include-of-libc-asm-pageh.patch added to -mm tree
Date: Wed, 31 Oct 2007 13:36:35 -0700
Message-ID: <200710312036.l9VKaZh4026972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565AbXJaUhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 16:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: remove last include of libc asm/page.h
has been added to the -mm tree.  Its filename is
     uml-remove-last-include-of-libc-asm-pageh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove last include of libc asm/page.h
From: Jeff Dike <jdike@addtoit.com>

asm/page.h is disappearing from the libc headers and we don't need it anyway.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/clone.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/um/kernel/skas/clone.c~uml-remove-last-include-of-libc-asm-pageh arch/um/kernel/skas/clone.c
--- a/arch/um/kernel/skas/clone.c~uml-remove-last-include-of-libc-asm-pageh
+++ a/arch/um/kernel/skas/clone.c
@@ -3,7 +3,6 @@
 #include <sys/mman.h>
 #include <sys/time.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "as-layout.h"
 #include "ptrace_user.h"
 #include "skas.h"
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
arch-um-drivers-ubd_kernc-a-warning-fix.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
