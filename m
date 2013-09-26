From: akpm@linux-foundation.org
Subject: + mm-kconfig-fix-grammar-s-an-a.patch added to -mm tree
Date: Thu, 26 Sep 2013 14:49:26 -0700
Message-ID: <5244abe6.9VTiGGj1nTTI7nEl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3IZVt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: + mm-kconfig-fix-grammar-s-an-a.patch added to -mm tree
To: geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:49:26 -0700


The patch titled
     Subject: mm/Kconfig: fix grammar: s/an/a/
has been added to the -mm tree.  Its filename is
     mm-kconfig-fix-grammar-s-an-a.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kconfig-fix-grammar-s-an-a.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kconfig-fix-grammar-s-an-a.patch

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
Subject: mm/Kconfig: fix grammar: s/an/a/

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-kconfig-fix-grammar-s-an-a mm/Kconfig
--- a/mm/Kconfig~mm-kconfig-fix-grammar-s-an-a
+++ a/mm/Kconfig
@@ -20,7 +20,7 @@ config FLATMEM_MANUAL
 
 	  Some users of more advanced features like NUMA and
 	  memory hotplug may have different options here.
-	  DISCONTIGMEM is an more mature, better tested system,
+	  DISCONTIGMEM is a more mature, better tested system,
 	  but is incompatible with memory hotplug and may suffer
 	  decreased performance over SPARSEMEM.  If unsure between
 	  "Sparse Memory" and "Discontiguous Memory", choose
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-kconfig-fix-grammar-s-an-a.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
linux-next.patch

