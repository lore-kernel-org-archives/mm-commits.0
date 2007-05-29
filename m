From: akpm@linux-foundation.org
Subject: + remove-dead-references-to-module_parm-macro.patch added to -mm tree
Date: Tue, 29 May 2007 16:11:02 -0700
Message-ID: <200705292311.l4TNB2MV014021@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbXE2XLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 19:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Remove dead references to MODULE_PARM macro
has been added to the -mm tree.  Its filename is
     remove-dead-references-to-module_parm-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove dead references to MODULE_PARM macro
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the useless references to the obsolete MODULE_PARM macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmmca.c |    7 -------
 1 files changed, 7 deletions(-)

diff -puN drivers/scsi/ibmmca.c~remove-dead-references-to-module_parm-macro drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c~remove-dead-references-to-module_parm-macro
+++ a/drivers/scsi/ibmmca.c
@@ -460,13 +460,6 @@ module_param(boot_options, charp, 0);
 module_param_array(io_port, int, NULL, 0);
 module_param_array(scsi_id, int, NULL, 0);
 
-#if 0 /* FIXME: No longer exist? --RR */
-MODULE_PARM(display, "1i");
-MODULE_PARM(adisplay, "1i");
-MODULE_PARM(normal, "1i");
-MODULE_PARM(ansi, "1i");
-#endif
-
 MODULE_LICENSE("GPL");
 #endif
 /*counter of concurrent disk read/writes, to turn on/off disk led */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-arm-master.patch
git-ieee1394.patch
git-kbuild.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-dead-references-to-module_parm-macro.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
