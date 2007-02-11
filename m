From: akpm@linux-foundation.org
Subject: - uml-console-whitespace-and-comment-tidying.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:19 -0800
Message-ID: <200702112248.l1BMmJcK015614@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674AbXBKWsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: console whitespace and comment tidying
has been removed from the -mm tree.  Its filename was
     uml-console-whitespace-and-comment-tidying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: console whitespace and comment tidying
From: Jeff Dike <jdike@addtoit.com>

Some comment and whitespace cleanups in the console and mconsole code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/stdio_console.c |    2 --
 arch/um/include/mconsole_kern.h |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/um/drivers/stdio_console.c~uml-console-whitespace-and-comment-tidying arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-console-whitespace-and-comment-tidying
+++ a/arch/um/drivers/stdio_console.c
@@ -30,8 +30,6 @@
 
 #define MAX_TTYS (16)
 
-/* ----------------------------------------------------------------------------- */
-
 /* Referenced only by tty_driver below - presumably it's locked correctly
  * by the tty driver.
  */
diff -puN arch/um/include/mconsole_kern.h~uml-console-whitespace-and-comment-tidying arch/um/include/mconsole_kern.h
--- a/arch/um/include/mconsole_kern.h~uml-console-whitespace-and-comment-tidying
+++ a/arch/um/include/mconsole_kern.h
@@ -20,7 +20,7 @@ struct mc_device {
 	char *name;
 	int (*config)(char *, char **);
 	int (*get_config)(char *, char *, int, char **);
-        int (*id)(char **, int *, int *);
+	int (*id)(char **, int *, int *);
 	int (*remove)(int, char **);
 };
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
