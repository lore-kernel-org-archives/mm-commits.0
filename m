From: akpm@linux-foundation.org
Subject: - kmod-fix-varargs-kernel-doc.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:05 -0800
Message-ID: <200901072220.n07MK5mA019369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763342AbZAGWhL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     kmod: fix varargs kernel-doc
has been removed from the -mm tree.  Its filename was
     kmod-fix-varargs-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmod: fix varargs kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix varargs kernel-doc format in kmod.c:
Use @... instead of @varargs.

Warning(kernel/kmod.c:67): Excess function parameter or struct member 'varargs' description in 'request_module'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~kmod-fix-varargs-kernel-doc kernel/kmod.c
--- a/kernel/kmod.c~kmod-fix-varargs-kernel-doc
+++ a/kernel/kmod.c
@@ -51,8 +51,8 @@ char modprobe_path[KMOD_PATH_LEN] = "/sb
 
 /**
  * request_module - try to load a kernel module
- * @fmt:     printf style format string for the name of the module
- * @varargs: arguements as specified in the format string
+ * @fmt: printf style format string for the name of the module
+ * @...: arguments as specified in the format string
  *
  * Load a module using the user mode module loader. The function returns
  * zero on success or a negative errno code on failure. Note that a
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

