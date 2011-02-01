From: akpm@linux-foundation.org
Subject: [folded] thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix.patch removed from -mm tree
Date: Tue, 01 Feb 2011 15:46:10 -0800
Message-ID: <201102012346.p11NkAV3005575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab1BAXq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 18:46:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, andi@firstfloor.org, jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix
has been removed from the -mm tree.  Its filename was
     thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix.patch

This patch was dropped because it was folded into thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix spello in comment

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix
+++ a/mm/huge_memory.c
@@ -1163,7 +1163,7 @@ static void __split_huge_page_refcount(s
 		smp_mb();
 
 		/*
-		 * remain hwpoison flag of the poisoned tail page:
+		 * retain hwpoison flag of the poisoned tail page:
 		 *   fix for the unsuitable process killed on Guest Machine(KVM)
 		 *   by the memory-failure.
 		 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-epoll_wait-should-not-use-timespec_add_ns.patch
maintainers-fixup-simtec-support-email-entries.patch
thp-fix-splitting-of-hwpoisoned-hugepages.patch
thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages.patch
thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

