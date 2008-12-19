From: akpm@linux-foundation.org
Subject: + doc-reformat-some-long-lines-in-kernel-parameterstxt.patch added to -mm tree
Date: Fri, 19 Dec 2008 13:17:37 -0800
Message-ID: <200812192117.mBJLHbaC027698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbYLSVSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Dec 2008 16:18:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     doc: reformat some long lines in kernel-parameters.txt
has been added to the -mm tree.  Its filename is
     doc-reformat-some-long-lines-in-kernel-parameterstxt.patch

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
Subject: doc: reformat some long lines in kernel-parameters.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Reformat text to (mostly) stay within 80 columns of text.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~doc-reformat-some-long-lines-in-kernel-parameterstxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-reformat-some-long-lines-in-kernel-parameterstxt
+++ a/Documentation/kernel-parameters.txt
@@ -1813,10 +1813,10 @@ and is between 256 and 4096 characters. 
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
-	dynamic_printk
-			Enables pr_debug()/dev_dbg() calls if
-			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled. These can also
-			be switched on/off via <debugfs>/dynamic_printk/modules
+	dynamic_printk	Enables pr_debug()/dev_dbg() calls if
+			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled.
+			These can also be switched on/off via
+			<debugfs>/dynamic_printk/modules
 
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
@@ -1904,7 +1904,7 @@ and is between 256 and 4096 characters. 
 
 	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
-			See arch/*/kernel/reboot.c or arch/*/kernel/process.c			
+			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
@@ -2477,8 +2477,8 @@ and is between 256 and 4096 characters. 
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
 
-	norandmaps	Don't use address space randomization
-			Equivalent to echo 0 > /proc/sys/kernel/randomize_va_space
+	norandmaps	Don't use address space randomization.  Equivalent to
+			echo 0 > /proc/sys/kernel/randomize_va_space
 
 ______________________________________________________________________
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
mtd-fix-dataflash-printk-formats.patch
mtd-fix-m25p80-printk-formats.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-how-to-use-doc-section-blocks.patch
docs-add-more-early-params-to-kernel-parameterstxt.patch
doc-reformat-some-long-lines-in-kernel-parameterstxt.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch

