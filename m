From: akpm@linux-foundation.org
Subject: +
 mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch added to -mm tree
Date: Thu, 02 Jun 2016 16:35:08 -0700
Message-ID: <5750c2ac.FlXWuuf9c/r1QwZO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbcFBXfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch

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
Subject: mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#17: 
Thus, checks for "frontswap_enabled" are replaced with "frontswap_enabled()"

WARNING: space prohibited between function name and open parenthesis '('
#208: FILE: mm/frontswap.c:255:
+	VM_BUG_ON (!frontswap_ops);

total: 0 errors, 2 warnings, 188 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-frontswap-convert-frontswap_enabled-to-static-key.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/frontswap.c~mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes mm/frontswap.c
--- a/mm/frontswap.c~mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes
+++ a/mm/frontswap.c
@@ -252,7 +252,7 @@ int __frontswap_store(struct page *page)
 	pgoff_t offset = swp_offset(entry);
 	struct frontswap_ops *ops;
 
-	VM_BUG_ON (!frontswap_ops);
+	VM_BUG_ON(!frontswap_ops);
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(sis == NULL);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-fix-overflow-in-vm_map_ram-fix.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

