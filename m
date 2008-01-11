From: akpm@linux-foundation.org
Subject: + cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris.patch added to -mm tree
Date: Fri, 11 Jan 2008 15:49:20 -0800
Message-ID: <200801112349.m0BNnKEV004153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757148AbYAKXtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 18:49:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     CRIS: define __ARCH_WANT_SYS_RT_SIGSUSPEND in unistd.h for CRIS
has been added to the -mm tree.  Its filename is
     cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CRIS: define __ARCH_WANT_SYS_RT_SIGSUSPEND in unistd.h for CRIS
From: Jesper Nilsson <jesper.nilsson@axis.com>

This allows us to use the commong sys_rt_sigsuspend instead of
having our own.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/unistd.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-cris/unistd.h~cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris include/asm-cris/unistd.h
--- a/include/asm-cris/unistd.h~cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris
+++ a/include/asm-cris/unistd.h
@@ -358,6 +358,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
 
 /*
  * "Conditional" syscalls
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-v10-correct-do_signal-to-fix-oops-and-clean-up-signal-handling-in-general.patch
cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile.patch
cris-v10-driver-for-ds1302-needs-to-include-cris-specific-i2ch.patch
git-kbuild.patch
git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch
cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris.patch
avoid-overflows-in-kernel-timec.patch
