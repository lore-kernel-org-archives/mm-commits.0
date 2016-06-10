From: akpm@linux-foundation.org
Subject: [withdrawn] m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch
 removed from -mm tree
Date: Fri, 10 Jun 2016 14:22:58 -0700
Message-ID: <575b2fb2.83/pt+Cwb9FPzFMB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbcFJVW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 17:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sudip.mukherjee@codethink.co.uk, sudipm.mukherjee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r-add-__ucmpdi2-to-fix-build-failure-fix
has been removed from the -mm tree.  Its filename was
     m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: m32r-add-__ucmpdi2-to-fix-build-failure-fix

avoid extern declaration in .c file

Cc: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/m32r_ksyms.c |    1 -
 arch/m32r/lib/libgcc.h        |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m32r/kernel/m32r_ksyms.c~m32r-add-__ucmpdi2-to-fix-build-failure-fix arch/m32r/kernel/m32r_ksyms.c
--- a/arch/m32r/kernel/m32r_ksyms.c~m32r-add-__ucmpdi2-to-fix-build-failure-fix
+++ a/arch/m32r/kernel/m32r_ksyms.c
@@ -41,7 +41,6 @@ EXPORT_SYMBOL(cpu_data);
 EXPORT_SYMBOL(smp_flush_tlb_page);
 #endif
 
-extern int __ucmpdi2(unsigned long long a, unsigned long long b);
 EXPORT_SYMBOL(__ucmpdi2);
 
 /* compiler generated symbol */
diff -puN arch/m32r/lib/libgcc.h~m32r-add-__ucmpdi2-to-fix-build-failure-fix arch/m32r/lib/libgcc.h
--- a/arch/m32r/lib/libgcc.h~m32r-add-__ucmpdi2-to-fix-build-failure-fix
+++ a/arch/m32r/lib/libgcc.h
@@ -22,3 +22,4 @@ typedef union {
 
 #endif /* __ASM_LIBGCC_H */
 
+extern int __ucmpdi2(unsigned long long a, unsigned long long b);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

