From: akpm@linux-foundation.org
Subject: + include-linux-printkh-use-space-after-define.patch added to -mm tree
Date: Tue, 07 Dec 2010 15:29:53 -0800
Message-ID: <201012072329.oB7NTrvb014434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964Ab0LGXaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 18:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, mpm@selenic.com


The patch titled
     include/linux/printk.h: use space after #define
has been added to the -mm tree.  Its filename is
     include-linux-printkh-use-space-after-define.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/printk.h: use space after #define
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/printk.h~include-linux-printkh-use-space-after-define include/linux/printk.h
--- a/include/linux/printk.h~include-linux-printkh-use-space-after-define
+++ a/include/linux/printk.h
@@ -4,14 +4,14 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-#define	KERN_EMERG	"<0>"	/* system is unusable			*/
-#define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
-#define	KERN_CRIT	"<2>"	/* critical conditions			*/
-#define	KERN_ERR	"<3>"	/* error conditions			*/
-#define	KERN_WARNING	"<4>"	/* warning conditions			*/
-#define	KERN_NOTICE	"<5>"	/* normal but significant condition	*/
-#define	KERN_INFO	"<6>"	/* informational			*/
-#define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
+#define KERN_EMERG	"<0>"	/* system is unusable			*/
+#define KERN_ALERT	"<1>"	/* action must be taken immediately	*/
+#define KERN_CRIT	"<2>"	/* critical conditions			*/
+#define KERN_ERR	"<3>"	/* error conditions			*/
+#define KERN_WARNING	"<4>"	/* warning conditions			*/
+#define KERN_NOTICE	"<5>"	/* normal but significant condition	*/
+#define KERN_INFO	"<6>"	/* informational			*/
+#define KERN_DEBUG	"<7>"	/* debug-level messages			*/
 
 /* Use the default kernel loglevel */
 #define KERN_DEFAULT	"<d>"
@@ -20,7 +20,7 @@ extern const char linux_proc_banner[];
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define	KERN_CONT	"<c>"
+#define KERN_CONT	"<c>"
 
 extern int console_printk[];
 
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
include-linux-printkh-move-console-functions-and-variables-together.patch
include-linux-printkh-use-space-after-define.patch
include-linux-printkh-use-and-neaten-no_printk.patch
include-linux-printkh-add-pr_level_once-macros.patch
include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard.patch
include-linux-printkh-organize-printk_ratelimited-macros.patch
include-linux-printkh-use-tab-not-spaces-for-indent.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
scripts-get_maintainerpl-use-git-fallback-more-often.patch
scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

