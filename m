From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 10 Oct 2012 12:48:17 -0700
Message-ID: <20121010194818.DC857100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55316 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab2JJTsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 15:48:20 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so108451qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 12:48:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig            |    3 ---
 arch/arm/Kconfig              |    3 ---
 arch/h8300/include/asm/Kbuild |    4 ----
 arch/m32r/include/asm/Kbuild  |    4 ----
 arch/s390/Kconfig             |    3 ---
 arch/um/kernel/exec.c         |    7 -------
 arch/um/kernel/syscall.c      |   13 -------------
 7 files changed, 37 deletions(-)

diff -puN arch/alpha/Kconfig~linux-next-git-rejects arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~linux-next-git-rejects
+++ a/arch/alpha/Kconfig
@@ -20,11 +20,8 @@ config ALPHA
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
-<<<<<<< HEAD
-=======
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
->>>>>>> linux-next/akpm-base
 	select GENERIC_KERNEL_THREAD
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
diff -puN arch/arm/Kconfig~linux-next-git-rejects arch/arm/Kconfig
--- a/arch/arm/Kconfig~linux-next-git-rejects
+++ a/arch/arm/Kconfig
@@ -52,11 +52,8 @@ config ARM
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select DCACHE_WORD_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && !CPU_BIG_ENDIAN
-<<<<<<< HEAD
-=======
 	select HAVE_MOD_ARCH_SPECIFIC if ARM_UNWIND
 	select MODULES_USE_ELF_REL
->>>>>>> linux-next/akpm-base
 	select GENERIC_KERNEL_THREAD
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
diff -puN arch/h8300/include/asm/Kbuild~linux-next-git-rejects arch/h8300/include/asm/Kbuild
--- a/arch/h8300/include/asm/Kbuild~linux-next-git-rejects
+++ a/arch/h8300/include/asm/Kbuild
@@ -1,9 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
-<<<<<<< HEAD
-generic-y += clkdev.h
-=======
 generic-y	+= module.h
 generic-y	+= clkdev.h
->>>>>>> linux-next/akpm-base
 generic-y += exec.h
diff -puN arch/m32r/include/asm/Kbuild~linux-next-git-rejects arch/m32r/include/asm/Kbuild
--- a/arch/m32r/include/asm/Kbuild~linux-next-git-rejects
+++ a/arch/m32r/include/asm/Kbuild
@@ -1,9 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
-<<<<<<< HEAD
-generic-y += clkdev.h
-=======
 generic-y	+= module.h
 generic-y	+= clkdev.h
->>>>>>> linux-next/akpm-base
 generic-y += exec.h
diff -puN arch/s390/Kconfig~linux-next-git-rejects arch/s390/Kconfig
--- a/arch/s390/Kconfig~linux-next-git-rejects
+++ a/arch/s390/Kconfig
@@ -135,11 +135,8 @@ config S390
 	select GENERIC_CLOCKEVENTS
 	select KTIME_SCALAR if 32BIT
 	select HAVE_ARCH_SECCOMP_FILTER
-<<<<<<< HEAD
-=======
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
->>>>>>> linux-next/akpm-base
 	select GENERIC_KERNEL_THREAD
 
 config SCHED_OMIT_FRAME_POINTER
diff -puN arch/um/kernel/exec.c~linux-next-git-rejects arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~linux-next-git-rejects
+++ a/arch/um/kernel/exec.c
@@ -12,17 +12,10 @@
 #include <asm/current.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
-<<<<<<< HEAD
-#include <as-layout.h>
-#include <mem_user.h>
-#include <skas.h>
-#include <os.h>
-=======
 #include "as-layout.h"
 #include "mem_user.h"
 #include "skas.h"
 #include "os.h"
->>>>>>> linux-next/akpm-base
 
 void flush_thread(void)
 {
diff -puN arch/um/kernel/syscall.c~linux-next-git-rejects arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~linux-next-git-rejects
+++ a/arch/um/kernel/syscall.c
@@ -3,18 +3,6 @@
  * Licensed under the GPL
  */
 
-<<<<<<< HEAD
-#include <linux/file.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/sched.h>
-#include <linux/utsname.h>
-#include <linux/syscalls.h>
-#include <asm/current.h>
-#include <asm/mman.h>
-#include <asm/uaccess.h>
-#include <asm/unistd.h>
-=======
 #include "linux/file.h"
 #include "linux/fs.h"
 #include "linux/mm.h"
@@ -25,7 +13,6 @@
 #include "asm/mman.h"
 #include "asm/uaccess.h"
 #include "asm/unistd.h"
->>>>>>> linux-next/akpm-base
 
 long sys_fork(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-powerpc-platforms-pseries-hotplug-memoryc-fix-section-handling-code.patch
fs-block_devc-set_blocksize-use-mapping_mapped.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

