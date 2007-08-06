From: akpm@linux-foundation.org
Subject: - mips-remove-some-duplicate-includes.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:24 -0700
Message-ID: <200708060753.l767rOgE016331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756638AbXHFHxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: remove some duplicate includes
has been removed from the -mm tree.  Its filename was
     mips-remove-some-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: remove some duplicate includes
From: Jesper Juhl <jesper.juhl@gmail.com>

Remove some duplicate includes from arch/mips/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/signal32.c   |    1 -
 arch/mips/lemote/lm2e/irq.c   |    1 -
 arch/mips/mipssim/sim_setup.c |    1 -
 3 files changed, 3 deletions(-)

diff -puN arch/mips/kernel/signal32.c~mips-remove-some-duplicate-includes arch/mips/kernel/signal32.c
--- a/arch/mips/kernel/signal32.c~mips-remove-some-duplicate-includes
+++ a/arch/mips/kernel/signal32.c
@@ -18,7 +18,6 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/ptrace.h>
-#include <linux/compat.h>
 #include <linux/suspend.h>
 #include <linux/compiler.h>
 #include <linux/uaccess.h>
diff -puN arch/mips/lemote/lm2e/irq.c~mips-remove-some-duplicate-includes arch/mips/lemote/lm2e/irq.c
--- a/arch/mips/lemote/lm2e/irq.c~mips-remove-some-duplicate-includes
+++ a/arch/mips/lemote/lm2e/irq.c
@@ -25,7 +25,6 @@
  */
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/irq.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff -puN arch/mips/mipssim/sim_setup.c~mips-remove-some-duplicate-includes arch/mips/mipssim/sim_setup.c
--- a/arch/mips/mipssim/sim_setup.c~mips-remove-some-duplicate-includes
+++ a/arch/mips/mipssim/sim_setup.c
@@ -22,7 +22,6 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/ioport.h>
-#include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-acpi.patch
git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
git-mtd.patch
git-ubi.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
