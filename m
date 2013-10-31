From: akpm@linux-foundation.org
Subject: [merged] mm-kconfig-fix-grammar-s-an-a.patch removed from -mm
 tree
Date: Thu, 31 Oct 2013 10:59:55 -0700
Message-ID: <52729a9b.JcVMaXR4IheyoFef%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JaR7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 13:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: [merged] mm-kconfig-fix-grammar-s-an-a.patch removed from -mm tree
To: geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 10:59:55 -0700


The patch titled
     Subject: mm/Kconfig: fix grammar: s/an/a/
has been removed from the -mm tree.  Its filename was
     mm-kconfig-fix-grammar-s-an-a.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
kernel-sysc-remove-obsolete-include-linux-kexech.patch
inith-document-the-existence-of-__initconst.patch
init-make-init-failures-more-explicit.patch
linux-next.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
m68k-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail-fix.patch
m68k-handle-pgtable_page_ctor-fail-fix-fix.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch

