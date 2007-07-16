From: akpm@linux-foundation.org
Subject: - remove-final-two-references-to-__obsolete_setup-macro.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:17 -0700
Message-ID: <200707162057.l6GKvHlK002171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758549AbXGPVHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Remove final two references to "__obsolete_setup" macro
has been removed from the -mm tree.  Its filename was
     remove-final-two-references-to-__obsolete_setup-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove final two references to "__obsolete_setup" macro
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/init.h~remove-final-two-references-to-__obsolete_setup-macro include/linux/init.h
--- a/include/linux/init.h~remove-final-two-references-to-__obsolete_setup-macro
+++ a/include/linux/init.h
@@ -171,9 +171,6 @@ struct obs_kernel_param {
 #define __setup(str, fn)					\
 	__setup_param(str, fn, fn, 0)
 
-#define __obsolete_setup(str)					\
-	__setup_null_param(str, __LINE__)
-
 /* NOTE: fn is as per module_param, not __setup!  Emits warning if fn
  * returns non-zero. */
 #define early_param(str, fn)					\
@@ -239,7 +236,6 @@ void __init parse_early_param(void);
 #define __setup_param(str, unique_id, fn)	/* nothing */
 #define __setup_null_param(str, unique_id) 	/* nothing */
 #define __setup(str, func) 			/* nothing */
-#define __obsolete_setup(str) 			/* nothing */
 #endif
 
 /* Data marked not to be saved by software suspend */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
