From: akpm@linux-foundation.org
Subject: [withdrawn] um-fix-strrchr-problems.patch removed from -mm tree
Date: Mon, 29 Aug 2011 14:50:34 -0700
Message-ID: <201108292150.p7TLoZgX031816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977Ab1H2VvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 17:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, richard@nod.at, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     um: fix strrchr problems
has been removed from the -mm tree.  Its filename was
     um-fix-strrchr-problems.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: fix strrchr problems
From: Al Viro <viro@ftp.linux.org.uk>

Several years old patch, originally by jdike, I think...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Makefile~um-fix-strrchr-problems arch/um/Makefile
--- a/arch/um/Makefile~um-fix-strrchr-problems
+++ a/arch/um/Makefile
@@ -41,7 +41,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_D
 KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
 	-Din6addr_loopback=kernel_in6addr_loopback \
-	-Din6addr_any=kernel_in6addr_any
+	-Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr
 
 KBUILD_AFLAGS += $(ARCH_INCLUDE)
 
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

um-fix-oopsable-race-in-line_close.patch
um-winch_interrupt-can-happen-inside-of-free_winch.patch
um-fix-free_winch-mess.patch
um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch.patch
um-clean-arch_ptrace-up-a-bit.patch
slab-leaks3-default-y.patch

