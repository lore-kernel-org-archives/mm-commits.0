From: akpm@linux-foundation.org
Subject: + mm-fix-cross_memory_attach-help-text-grammar.patch added to -mm tree
Date: Fri, 08 Aug 2014 15:21:01 -0700
Message-ID: <53e54d4d.xT5lbmlyS4cl4499%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:53401 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919AbaHHWVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 18:21:02 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1583248pdj.2
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 15:21:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix CROSS_MEMORY_ATTACH help text grammar
has been added to the -mm tree.  Its filename is
     mm-fix-cross_memory_attach-help-text-grammar.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-cross_memory_attach-help-text-grammar.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-cross_memory_attach-help-text-grammar.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm: fix CROSS_MEMORY_ATTACH help text grammar

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~mm-fix-cross_memory_attach-help-text-grammar init/Kconfig
--- a/init/Kconfig~mm-fix-cross_memory_attach-help-text-grammar
+++ a/init/Kconfig
@@ -268,7 +268,7 @@ config CROSS_MEMORY_ATTACH
 	help
 	  Enabling this option adds the system calls process_vm_readv and
 	  process_vm_writev which allow a process with the correct privileges
-	  to directly read from or write to to another process's address space.
+	  to directly read from or write to another process' address space.
 	  See the man page for more details.
 
 config FHANDLE
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
revert-slab-remove-bad_alien_magic.patch
initramfs-support-initrd-that-is-bigger-than-2gib.patch
scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86.patch
mm-fix-cross_memory_attach-help-text-grammar.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
linux-next.patch

