From: akpm@linux-foundation.org
Subject: + mm-count-swap-usage-checkpatch-fixes.patch added to -mm tree
Date: Mon, 21 Dec 2009 16:58:09 -0800
Message-ID: <200912220058.nBM0w9Xr006874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbZLVA6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 19:58:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     mm-count-swap-usage-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-count-swap-usage-checkpatch-fixes.patch

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
Subject: mm-count-swap-usage-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#150: FILE: mm/memory.c:984:
+^I^I  ^Iif (unlikely(!free_swap_and_cache(entry)))$

total: 1 errors, 0 warnings, 102 lines checked

./patches/mm-count-swap-usage.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-count-swap-usage-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-count-swap-usage-checkpatch-fixes
+++ a/mm/memory.c
@@ -981,7 +981,7 @@ static unsigned long zap_pte_range(struc
 
 			if (!non_swap_entry(entry))
 				rss[MM_SWAPENTS]--;
-		  	if (unlikely(!free_swap_and_cache(entry)))
+			if (unlikely(!free_swap_and_cache(entry)))
 				print_bad_pte(vma, addr, ptent, NULL);
 		}
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kfifo-move-struct-kfifo-in-place.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-squish-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

