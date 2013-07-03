From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch removed from -mm tree
Date: Wed, 03 Jul 2013 14:33:49 -0700
Message-ID: <51d498bd.IOiIzcRtZ/atu9Kf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab3GCVdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tim.c.chen@linux.intel.com, fengguang.wu@intel.com, eric.dumazet@gmail.com, dave.hansen@intel.com, ak@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,ak@linux.intel.com,dave.hansen@intel.com,eric.dumazet@gmail.com,fengguang.wu@intel.com,tim.c.chen@linux.intel.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:33:49 -0700


The patch titled
     Subject: mm-tune-vm_committed_as-percpu_counter-batching-size-fix
has been removed from the -mm tree.  Its filename was
     mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch

This patch was dropped because it was folded into mm-tune-vm_committed_as-percpu_counter-batching-size.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-tune-vm_committed_as-percpu_counter-batching-size-fix

fix section mismatch

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mm_init.c~mm-tune-vm_committed_as-percpu_counter-batching-size-fix mm/mm_init.c
--- a/mm/mm_init.c~mm-tune-vm_committed_as-percpu_counter-batching-size-fix
+++ a/mm/mm_init.c
@@ -177,7 +177,7 @@ static int __meminit mm_compute_batch_no
 	return NOTIFY_OK;
 }
 
-static struct notifier_block compute_batch_nb = {
+static struct notifier_block compute_batch_nb __meminitdata = {
 	.notifier_call = mm_compute_batch_notifier,
 	.priority = IPC_CALLBACK_PRI, /* use lowest priority */
 };
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
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
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

