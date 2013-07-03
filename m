From: akpm@linux-foundation.org
Subject: [folded-merged]
 swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
 removed from -mm tree
Date: Wed, 03 Jul 2013 14:34:21 -0700
Message-ID: <51d498dd.3k42N23XC8KFiUK4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab3GCVeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, aquini@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,aquini@redhat.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:34:21 -0700


The patch titled
     Subject: swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix
has been removed from the -mm tree.  Its filename was
     swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch

This patch was dropped because it was folded into swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix

tweak comments

Cc: Hugh Dickins <hughd@google.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/swapfile.c~swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix mm/swapfile.c
--- a/mm/swapfile.c~swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix
+++ a/mm/swapfile.c
@@ -2140,17 +2140,17 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 		if ((swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
 			/*
-			 * When discard is enabled for swap, with no particular
-			 * policy flagged, we set all swap discard flags here
-			 * in order to sustain backward compatibility with
-			 * older swapon(8) releases.
+			 * When discard is enabled for swap with no particular
+			 * policy flagged, we set all swap discard flags here in
+			 * order to sustain backward compatibility with older
+			 * swapon(8) releases.
 			 */
 			p->flags |= (SWP_DISCARDABLE | SWP_AREA_DISCARD |
 				     SWP_PAGE_DISCARD);
 
 			/*
 			 * By flagging sys_swapon, a sysadmin can tell us to
-			 * either do sinle-time area discards only, or to just
+			 * either do single-time area discards only, or to just
 			 * perform discards for released swap page-clusters.
 			 * Now it's time to adjust the p->flags accordingly.
 			 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-support-mmap-on-proc-vmcore.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix-fix-fix.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
rtc-add-nxp-pcf2127-support-i2c-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch

