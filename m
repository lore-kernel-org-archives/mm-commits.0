From: akpm@linux-foundation.org
Subject: [merged] include-linux-printkh-use-space-after-define.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:04:21 -0800
Message-ID: <201101132007.p0DK72tV029798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933638Ab1AMUHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mingo@elte.hu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/printk.h: use space after #define
has been removed from the -mm tree.  Its filename was
     include-linux-printkh-use-space-after-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch

