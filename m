From: akpm@linux-foundation.org
Subject: + uml-delete-some-unused-headers.patch added to -mm tree
Date: Wed, 07 Nov 2007 11:10:01 -0800
Message-ID: <200711071910.lA7JA3r5023517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40617 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362AbXKGTKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 14:10:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, rpjday@crashcourse.ca


The patch titled
     uml: delete some unused headers
has been added to the -mm tree.  Its filename is
     uml-delete-some-unused-headers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: delete some unused headers
From: Jeff Dike <jdike@addtoit.com>

Robert Day noticed a few unused headers in UML, so this gets rid of them.

Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/misc_constants.h |    6 ------
 arch/um/include/signal_kern.h    |   22 ----------------------
 arch/um/include/skas/mode-skas.h |   11 -----------
 3 files changed, 39 deletions(-)

diff -puN arch/um/include/misc_constants.h~uml-delete-some-unused-headers /dev/null
--- a/arch/um/include/misc_constants.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __MISC_CONSTANT_H_
-#define __MISC_CONSTANT_H_
-
-#include <user_constants.h>
-
-#endif
diff -puN arch/um/include/signal_kern.h~uml-delete-some-unused-headers /dev/null
--- a/arch/um/include/signal_kern.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __SIGNAL_KERN_H__
-#define __SIGNAL_KERN_H__
-
-extern int have_signals(void *t);
-
-#endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/skas/mode-skas.h~uml-delete-some-unused-headers /dev/null
--- a/arch/um/include/skas/mode-skas.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/*
- * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
- * Licensed under the GPL
- */
-
-#ifndef __MODE_SKAS_H__
-#define __MODE_SKAS_H__
-
-extern void kill_off_processes_skas(void);
-
-#endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
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
