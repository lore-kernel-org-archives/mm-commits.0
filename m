From: akpm@linux-foundation.org
Subject: + memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch added to -mm tree
Date: Mon, 13 Jun 2011 14:23:45 -0700
Message-ID: <201106132123.p5DLNkQo022722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299Ab1FMVYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jun 2011 17:24:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg-clear-mm-owner-when-last-possible-owner-leaves-fix
has been added to the -mm tree.  Its filename is
     memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch

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

origin.patch
backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated-fix.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch
memcg-fix-percpu-cached-charge-draining-frequency-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
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

