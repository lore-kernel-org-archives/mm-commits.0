From: akpm@linux-foundation.org
Subject: - uml-delete-some-unused-headers.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:57 -0800
Message-ID: <200802052235.m15MZc26012628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761137AbYBEWmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     uml: delete some unused headers
has been removed from the -mm tree.  Its filename was
     uml-delete-some-unused-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
