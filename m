From: akpm@linux-foundation.org
Subject: + remove-final-two-references-to-__obsolete_setup-macro.patch added to -mm tree
Date: Tue, 19 Jun 2007 15:53:39 -0700
Message-ID: <200706192253.l5JMrdYn023315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097AbXFSWxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 18:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Remove final two references to "__obsolete_setup" macro
has been added to the -mm tree.  Its filename is
     remove-final-two-references-to-__obsolete_setup-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove final two references to "__obsolete_setup" macro
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    4 ----
 1 files changed, 4 deletions(-)

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

ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
