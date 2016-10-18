From: akpm@linux-foundation.org
Subject: +
 powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix.patch added to -mm tree
Date: Tue, 18 Oct 2016 16:20:13 -0700
Message-ID: <5806ae2d.DnVO/XVGt3aYiiYV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58919 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbcJRXUO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 19:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bauerman@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix
has been added to the -mm tree.  Its filename is
     powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix.patch

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
Subject: powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix

Cc: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/Makefile~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix
+++ a/arch/powerpc/kernel/Makefile
@@ -129,7 +129,7 @@ ifneq ($(CONFIG_PPC_INDIRECT_PIO),y)
 obj-y				+= iomap.o
 endif
 
-ifeq ($(CONFIG_MODULES)$(CONFIG_WORD_SIZE),y64)
+ifeq ($(CONFIG_MODULES)$(BITS),y64)
 obj-y				+= elf_util_64.o
 endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

