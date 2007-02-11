From: akpm@linux-foundation.org
Subject: - uml-chan_userh-formatting-fices.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:51 -0800
Message-ID: <200702112248.l1BMmp5h015670@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59779 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932682AbXBKWsx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: chan_user.h formatting fixes
has been removed from the -mm tree.  Its filename was
     uml-chan_userh-formatting-fices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: chan_user.h formatting fixes
From: Jeff Dike <jdike@addtoit.com>

Whitespace fixes and emacs comment removal.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/chan_user.h |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN arch/um/include/chan_user.h~uml-chan_userh-formatting-fices arch/um/include/chan_user.h
--- a/arch/um/include/chan_user.h~uml-chan_userh-formatting-fices
+++ a/arch/um/include/chan_user.h
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000, 2001 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -54,14 +54,3 @@ __uml_help(fn, prefix "[0-9]*=<channel d
 );
 
 #endif
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
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
