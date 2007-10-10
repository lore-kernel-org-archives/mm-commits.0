From: akpm@linux-foundation.org
Subject: - remove-dead-references-to-module_parm-macro.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:54 -0700
Message-ID: <200710102110.l9ALAsqT025971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988AbXJJVVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Remove dead references to MODULE_PARM macro
has been removed from the -mm tree.  Its filename was
     remove-dead-references-to-module_parm-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove dead references to MODULE_PARM macro
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the useless references to the obsolete MODULE_PARM macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmmca.c |    7 -------
 1 file changed, 7 deletions(-)

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

git-avr32.patch
git-powerpc.patch
git-dvb.patch
git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-sh64.patch
git-scsi-misc.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
m32r-serial-remove-m32r_sio_share_irqs.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
remove-valueless-definition-of-hard-selected-ramfs-option.patch
remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
add-a-rounddown_pow_of_two-routine-to-log2h.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
ipc-namespace-remove-config-ipc-ns-fix.patch
delete-gcc-295-compatible-structure-definition.patch
documentation-delete-unreferenced-xterm-linuxxpm-file.patch
