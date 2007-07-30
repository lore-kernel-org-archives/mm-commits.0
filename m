From: akpm@linux-foundation.org
Subject: + ia64-remove-a-few-duplicate-includes.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:51:46 -0700
Message-ID: <200707302351.l6UNpkr7004825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763361AbXG3Xvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, tony.luck@intel.com


The patch titled
     ia64: remove a few duplicate includes
has been added to the -mm tree.  Its filename is
     ia64-remove-a-few-duplicate-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: remove a few duplicate includes
From: Jesper Juhl <jesper.juhl@gmail.com>

remove a few duplicate includes from arch/ia64/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/sys_ia32.c   |    1 -
 arch/ia64/kernel/setup.c    |    1 -
 arch/ia64/sn/kernel/setup.c |    1 -
 3 files changed, 3 deletions(-)

diff -puN arch/ia64/ia32/sys_ia32.c~ia64-remove-a-few-duplicate-includes arch/ia64/ia32/sys_ia32.c
--- a/arch/ia64/ia32/sys_ia32.c~ia64-remove-a-few-duplicate-includes
+++ a/arch/ia64/ia32/sys_ia32.c
@@ -34,7 +34,6 @@
 #include <linux/uio.h>
 #include <linux/nfs_fs.h>
 #include <linux/quota.h>
-#include <linux/syscalls.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/cache.h>
diff -puN arch/ia64/kernel/setup.c~ia64-remove-a-few-duplicate-includes arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~ia64-remove-a-few-duplicate-includes
+++ a/arch/ia64/kernel/setup.c
@@ -60,7 +60,6 @@
 #include <asm/smp.h>
 #include <asm/system.h>
 #include <asm/unistd.h>
-#include <asm/system.h>
 
 #if defined(CONFIG_SMP) && (IA64_CPU_SIZE > PAGE_SIZE)
 # error "struct cpuinfo_ia64 too big!"
diff -puN arch/ia64/sn/kernel/setup.c~ia64-remove-a-few-duplicate-includes arch/ia64/sn/kernel/setup.c
--- a/arch/ia64/sn/kernel/setup.c~ia64-remove-a-few-duplicate-includes
+++ a/arch/ia64/sn/kernel/setup.c
@@ -25,7 +25,6 @@
 #include <linux/interrupt.h>
 #include <linux/acpi.h>
 #include <linux/compiler.h>
-#include <linux/sched.h>
 #include <linux/root_dev.h>
 #include <linux/nodemask.h>
 #include <linux/pm.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
various-doc-kernel-parameters-fixes.patch
git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hid.patch
ia64-remove-a-few-duplicate-includes.patch
clean-up-duplicate-includes-in-drivers-input.patch
mips-remove-some-duplicate-includes.patch
git-mtd.patch
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
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
m68knommu-get-rid-of-duplicate-include.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
cciss-fix-memory-leak.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
