From: akpm@linux-foundation.org
Subject: - integrity-service-api-and-dummy-provider-cleanup-use-of-configh.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:10:02 -0800
Message-ID: <200703060210.l262A4mx008998@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965749AbXCFCKV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:10:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: cleanup use of config.h
has been removed from the -mm tree.  Its filename was
     integrity-service-api-and-dummy-provider-cleanup-use-of-configh.patch

This patch was dropped because it was folded into integrity-service-api-and-dummy-provider.patch

------------------------------------------------------
Subject: integrity: cleanup use of config.h
From: Kylene Jo Hall <kjhall@us.ibm.com>

This patch addresses this comment about the use of config.h in the
integrity .c files.

On Mon, 2006-09-18 at 16:54 -0400, Dave Jones wrote:
> You don't need to include config.h any more, kbuild does it for you.
> (Might want to check the other files for the same thing).
>
> 	Dave

Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/integrity.c       |    1 -
 security/integrity_dummy.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN security/integrity.c~integrity-service-api-and-dummy-provider-cleanup-use-of-configh security/integrity.c
--- a/security/integrity.c~integrity-service-api-and-dummy-provider-cleanup-use-of-configh
+++ a/security/integrity.c
@@ -11,7 +11,6 @@
  *      the Free Software Foundation, version 2 of the License.
  */
 
-#include <linux/config.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff -puN security/integrity_dummy.c~integrity-service-api-and-dummy-provider-cleanup-use-of-configh security/integrity_dummy.c
--- a/security/integrity_dummy.c~integrity-service-api-and-dummy-provider-cleanup-use-of-configh
+++ a/security/integrity_dummy.c
@@ -11,7 +11,6 @@
  *      the Free Software Foundation, version 2 of the License.
  */
 
-#include <linux/config.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
integrity-service-api-and-dummy-provider-cleanup-use-of-configh.patch
integrity-service-api-and-dummy-provider-compilation-warning-fix.patch
integrity-service-api-and-dummy-provider-fix.patch
slim-main-patch.patch
slim-main-patch-socket_post_create-hook-return-code.patch
slim-main-patch-misc-cleanups-requested-at-inclusion-time.patch
slim-main-patch-handle-failure-to-register.patch
slim-main-patch-fix-bug-with-mm_users-usage.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-main-include-fix.patch
slim-secfs-patch.patch
slim-secfs-patch-slim-correct-use-of-snprintf.patch
slim-secfs-patch-cleanup-use-of-configh.patch
slim-make-and-config-stuff.patch
slim-make-and-config-stuff-makefile-fix.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-secfs-inode-i_private-build-fix.patch
slim-documentation.patch
panic-on-slim-selinux.patch
