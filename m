From: akpm@osdl.org
Subject: + uml-console-whitespace-and-comment-tidying.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:31:57 -0800
Message-ID: <200701022131.l02LVva6030392@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbXABVfZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:35:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: console whitespace and comment tidying
has been added to the -mm tree.  Its filename is
     uml-console-whitespace-and-comment-tidying.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: console whitespace and comment tidying
From: Jeff Dike <jdike@addtoit.com>

Some comment and whitespace cleanups in the console and mconsole code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
