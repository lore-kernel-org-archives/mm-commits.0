From: akpm@linux-foundation.org
Subject: [folded] memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch removed from -mm tree
Date: Wed, 15 Jun 2011 15:04:28 -0700
Message-ID: <201106152204.p5FM4Th5022121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691Ab1FOWFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 18:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-clear-mm-owner-when-last-possible-owner-leaves-fix
has been removed from the -mm tree.  Its filename was
     memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch

This patch was dropped because it was folded into memcg-clear-mm-owner-when-last-possible-owner-leaves.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-clear-mm-owner-when-last-possible-owner-leaves-fix
From: Andrew Morton <akpm@linux-foundation.org>

tweak comments

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~memcg-clear-mm-owner-when-last-possible-owner-leaves-fix kernel/exit.c
--- a/kernel/exit.c~memcg-clear-mm-owner-when-last-possible-owner-leaves-fix
+++ a/kernel/exit.c
@@ -561,7 +561,7 @@ void exit_files(struct task_struct *tsk)
 
 #ifdef CONFIG_MM_OWNER
 /*
- * A task is exiting and if it owned mm, lets find a new owner for it
+ * A task is exiting.   If it owned this mm, find a new owner for the mm.
  */
 void mm_update_next_owner(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

