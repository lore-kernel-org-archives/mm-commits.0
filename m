From: akpm@linux-foundation.org
Subject: [merged] arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:00:16 -0800
Message-ID: <20121212200017.0C86220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:48325 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLUHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:07:51 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so65665lbc.3
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:07:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sparc/kernel/sys_sparc_64.c: s/COLOUR/COLOR/
has been removed from the -mm tree.  Its filename was
     arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/sparc/kernel/sys_sparc_64.c: s/COLOUR/COLOR/

Consistently spell this word across arch/sparc/mm and arch/sparc/kernel.

Acked-by: David Miller <davem@davemloft.net>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/sparc/kernel/sys_sparc_64.c~arch-sparc-kernel-sys_sparc_64c-s-colour-color arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~arch-sparc-kernel-sys_sparc_64c-s-colour-color
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -75,7 +75,7 @@ static inline int invalid_64bit_range(un
  *    the spitfire/niagara VA-hole.
  */
 
-static inline unsigned long COLOUR_ALIGN(unsigned long addr,
+static inline unsigned long COLOR_ALIGN(unsigned long addr,
 					 unsigned long pgoff)
 {
 	unsigned long base = (addr+SHMLBA-1)&~(SHMLBA-1);
@@ -113,7 +113,7 @@ unsigned long arch_get_unmapped_area(str
 
 	if (addr) {
 		if (do_color_align)
-			addr = COLOUR_ALIGN(addr, pgoff);
+			addr = COLOR_ALIGN(addr, pgoff);
 		else
 			addr = PAGE_ALIGN(addr);
 
@@ -176,7 +176,7 @@ arch_get_unmapped_area_topdown(struct fi
 	/* requesting a specific address */
 	if (addr) {
 		if (do_color_align)
-			addr = COLOUR_ALIGN(addr, pgoff);
+			addr = COLOR_ALIGN(addr, pgoff);
 		else
 			addr = PAGE_ALIGN(addr);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
thp-implement-splitting-pmd-for-huge-zero-page-fix.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix.patch
mm-memoryc-remove-unused-code-from-do_wp_page-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
drivers-video-add-support-for-the-solomon-ssd1307-oled-controller.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup-fix.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

