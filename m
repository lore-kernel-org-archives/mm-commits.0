From: akpm@linux-foundation.org
Subject: - integrity-service-api-and-dummy-provider-compilation-warning-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:10:06 -0800
Message-ID: <200703060210.l262A6hD009003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47478 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965776AbXCFCX0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:23:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: compilation warning fix
has been removed from the -mm tree.  Its filename was
     integrity-service-api-and-dummy-provider-compilation-warning-fix.patch

This patch was dropped because it was folded into integrity-service-api-and-dummy-provider.patch

------------------------------------------------------
Subject: slim: compilation warning fix
From: Kylene Jo Hall <kjhall@us.ibm.com>

There is a warning when compiling the intergity_dummy.c file about
vfs_getxattr not being defined.  This patch fixes that by adding the
xattr.h include file.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/integrity_dummy.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN security/integrity_dummy.c~integrity-service-api-and-dummy-provider-compilation-warning-fix security/integrity_dummy.c
--- a/security/integrity_dummy.c~integrity-service-api-and-dummy-provider-compilation-warning-fix
+++ a/security/integrity_dummy.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/integrity.h>
+#include <linux/xattr.h>
 
 /*
  *  Return the extended attribute
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
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
