From: akpm@linux-foundation.org
Subject: - doc-reformat-some-long-lines-in-kernel-parameterstxt.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:20 -0800
Message-ID: <200901072220.n07MKKdb019592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757742AbZAGWVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:21:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     doc: reformat some long lines in kernel-parameters.txt
has been removed from the -mm tree.  Its filename was
     doc-reformat-some-long-lines-in-kernel-parameterstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1799,10 +1799,10 @@ and is between 256 and 4096 characters. 
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
@@ -1890,7 +1890,7 @@ and is between 256 and 4096 characters. 
 
 	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
-			See arch/*/kernel/reboot.c or arch/*/kernel/process.c			
+			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
@@ -2438,8 +2438,8 @@ and is between 256 and 4096 characters. 
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
 
-	norandmaps	Don't use address space randomization
-			Equivalent to echo 0 > /proc/sys/kernel/randomize_va_space
+	norandmaps	Don't use address space randomization.  Equivalent to
+			echo 0 > /proc/sys/kernel/randomize_va_space
 
 ______________________________________________________________________
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

