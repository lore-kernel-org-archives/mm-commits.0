From: akpm@linux-foundation.org
Subject: - cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:38:42 -0800
Message-ID: <200801160138.m0G1cg7r013928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755125AbYAPBis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:38:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, mikael.starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS: define __ARCH_WANT_SYS_RT_SIGSUSPEND in unistd.h for CRIS
has been removed from the -mm tree.  Its filename was
     cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch
git-kbuild.patch
git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
avoid-overflows-in-kernel-timec.patch
