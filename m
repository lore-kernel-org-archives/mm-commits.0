From: akpm@linux-foundation.org
Subject: [folded-merged] userfaultfd-activate-syscall-fix.patch removed
 from -mm tree
Date: Fri, 04 Sep 2015 13:30:53 -0700
Message-ID: <55e9ff7d.aVJxG9xd9PS8lPyg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760279AbbIDUay (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 16:30:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: activate syscall fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-activate-syscall-fix.patch

This patch was dropped because it was folded into userfaultfd-activate-syscall.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: userfaultfd: activate syscall fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/unistd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/include/asm/unistd.h~userfaultfd-activate-syscall-fix arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~userfaultfd-activate-syscall-fix
+++ a/arch/powerpc/include/asm/unistd.h
@@ -12,7 +12,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define __NR_syscalls		364
+#define __NR_syscalls		365
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch
userfaultfd-activate-syscall.patch

