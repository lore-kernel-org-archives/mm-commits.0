From: akpm@linux-foundation.org
Subject: - uml-remove-last-include-of-libc-asm-pageh.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:00 -0800
Message-ID: <200711152111.lAFLB0HW015715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760450AbXKOVRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove last include of libc asm/page.h
has been removed from the -mm tree.  Its filename was
     uml-remove-last-include-of-libc-asm-pageh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kvm.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
