From: akpm@linux-foundation.org
Subject: - docs-add-more-early-params-to-kernel-parameterstxt.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:18 -0800
Message-ID: <200901072220.n07MKIXA019541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761444AbZAGWVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:21:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docs: add more early params to kernel-parameters.txt
has been removed from the -mm tree.  Its filename was
     docs-add-more-early-params-to-kernel-parameterstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docs: add more early params to kernel-parameters.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Add some (more) early_param boot options to kernel-parameters.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Documentation/kernel-parameters.txt~docs-add-more-early-params-to-kernel-parameterstxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~docs-add-more-early-params-to-kernel-parameterstxt
+++ a/Documentation/kernel-parameters.txt
@@ -1117,6 +1117,8 @@ and is between 256 and 4096 characters. 
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
+	lmb=debug	[KNL] Enable lmb debug messages.
+
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
 			See Documentation/blockdev/ramdisk.txt.
 
@@ -1569,6 +1571,10 @@ and is between 256 and 4096 characters. 
 
 	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
 
+	ohci1394_dma=early	[HW] enable debugging via the ohci1394 driver.
+			See Documentation/debugging-via-ohci1394.txt for more
+			info.
+
 	olpc_ec_timeout= [OLPC] ms delay when issuing EC commands
 			Rather than timing out after 20 ms if an EC
 			command is not properly ACKed, override the length
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

