From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 22 Oct 2012 12:01:23 -0700
Message-ID: <20121022190125.5F3FB5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:41260 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2JVTB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:01:27 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so182778eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:01:26 -0700 (PDT)
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
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

