From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 23 Oct 2012 11:51:54 -0700
Message-ID: <20121023185154.DEC19100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33391 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843Ab2JWSv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 14:51:56 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so521425vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 11:51:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/uapi/asm/Kbuild |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN arch/m68k/include/uapi/asm/Kbuild~linux-next-git-rejects arch/m68k/include/uapi/asm/Kbuild
--- a/arch/m68k/include/uapi/asm/Kbuild~linux-next-git-rejects
+++ a/arch/m68k/include/uapi/asm/Kbuild
@@ -2,23 +2,16 @@
 include include/uapi/asm-generic/Kbuild.asm
 
 header-y += a.out.h
-<<<<<<< HEAD
 header-y += auxvec.h
-=======
->>>>>>> linux-next/akpm-base
 header-y += byteorder.h
 header-y += cachectl.h
 header-y += fcntl.h
 header-y += ioctls.h
-<<<<<<< HEAD
 header-y += msgbuf.h
-=======
->>>>>>> linux-next/akpm-base
 header-y += param.h
 header-y += poll.h
 header-y += posix_types.h
 header-y += ptrace.h
-<<<<<<< HEAD
 header-y += sembuf.h
 header-y += setup.h
 header-y += shmbuf.h
@@ -30,11 +23,9 @@ header-y += stat.h
 header-y += swab.h
 header-y += termbits.h
 header-y += termios.h
-=======
 header-y += setup.h
 header-y += sigcontext.h
 header-y += signal.h
 header-y += stat.h
 header-y += swab.h
->>>>>>> linux-next/akpm-base
 header-y += unistd.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

