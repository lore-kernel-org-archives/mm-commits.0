From: akpm@linux-foundation.org
Subject: [merged] arch-x86-xen-mmuc-export-arbitrary_virt_to_machine.patch removed from -mm tree
Date: Tue, 18 Jan 2011 12:30:12 -0800
Message-ID: <201101182030.p0IKUCD2003541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412Ab1ARUmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 15:42:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeremy@goop.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     arch/x86/xen/mmu.c: export arbitrary_virt_to_machine()
has been removed from the -mm tree.  Its filename was
     arch-x86-xen-mmuc-export-arbitrary_virt_to_machine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/xen/mmu.c: export arbitrary_virt_to_machine()
From: Andrew Morton <akpm@linux-foundation.org>

x86_4 allmodconfig:

ERROR: "arbitrary_virt_to_machine" [drivers/xen/xen-gntdev.ko] undefined!

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/xen/mmu.c~arch-x86-xen-mmuc-export-arbitrary_virt_to_machine arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~arch-x86-xen-mmuc-export-arbitrary_virt_to_machine
+++ a/arch/x86/xen/mmu.c
@@ -201,6 +201,7 @@ xmaddr_t arbitrary_virt_to_machine(void 
 	offset = address & ~PAGE_MASK;
 	return XMADDR(((phys_addr_t)pte_mfn(*pte) << PAGE_SHIFT) + offset);
 }
+EXPORT_SYMBOL_GPL(arbitrary_virt_to_machine);
 
 void make_lowmem_page_readonly(void *vaddr)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-deactivate-invalidated-pages.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

