From: akpm@linux-foundation.org
Subject: - arm-fix-kernel-doc-syntax.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:01:43 -0800
Message-ID: <200812152001.mBFK1hTB030410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbYLOUBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:01:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     arm: fix kernel-doc syntax
has been removed from the -mm tree.  Its filename was
     arm-fix-kernel-doc-syntax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: fix kernel-doc syntax
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation to use correct syntax.  Even though this should be
moved to where the function is actually implemented...

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/include/mach/reset.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/arm/mach-pxa/include/mach/reset.h~arm-fix-kernel-doc-syntax arch/arm/mach-pxa/include/mach/reset.h
--- a/arch/arm/mach-pxa/include/mach/reset.h~arm-fix-kernel-doc-syntax
+++ a/arch/arm/mach-pxa/include/mach/reset.h
@@ -12,9 +12,8 @@ extern void clear_reset_status(unsigned 
 
 /**
  * init_gpio_reset() - register GPIO as reset generator
- *
- * @gpio - gpio nr
- * @output - set gpio as out/low instead of input during normal work
+ * @gpio: gpio nr
+ * @output: set gpio as out/low instead of input during normal work
  */
 extern int init_gpio_reset(int gpio, int output);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch

