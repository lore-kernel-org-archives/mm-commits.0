From: akpm@linux-foundation.org
Subject: + arch-x86-xen-mmuc-export-arbitrary_virt_to_machine.patch added to -mm tree
Date: Sun, 16 Jan 2011 16:54:52 -0800
Message-ID: <201101170054.p0H0sqUm029249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709Ab1AQAy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Jan 2011 19:54:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeremy@goop.org, sfr@canb.auug.org.au


The patch titled
     arch/x86/xen/mmu.c: export arbitrary_virt_to_machine()
has been added to the -mm tree.  Its filename is
     arch-x86-xen-mmuc-export-arbitrary_virt_to_machine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-nfc-pn544c-fix-min_t-warnings.patch
arch-x86-xen-mmuc-export-arbitrary_virt_to_machine.patch
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
mm-deactivate-invalidated-pages-fix.patch
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

