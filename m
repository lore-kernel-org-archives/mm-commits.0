From: akpm@linux-foundation.org
Subject: + userfaultfd-activate-syscall-fix.patch added to -mm tree
Date: Tue, 26 May 2015 15:16:07 -0700
Message-ID: <5564f0a7.Vo38zz3vYGSfstx3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbbEZWQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 May 2015 18:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: activate syscall fix
has been added to the -mm tree.  Its filename is
     userfaultfd-activate-syscall-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-activate-syscall-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-activate-syscall-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-pass-pfn-to-__free_pages_bootmem-fix.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init-fix.patch
userfaultfd-activate-syscall-fix.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

