From: akpm@linux-foundation.org
Subject: + vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch added to -mm tree
Date: Mon, 30 May 2011 00:55:00 -0700
Message-ID: <201105300754.p4U7su2x001583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165Ab1E3Hzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 May 2011 03:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com


The patch titled
     vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch

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
Subject: vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo* bar" should be "foo *bar"
#49: FILE: mm/thrash.c:32:
+static struct mem_cgroup* swap_token_memcg_from_mm(struct mm_struct *mm)

ERROR: "foo* bar" should be "foo *bar"
#60: FILE: mm/thrash.c:43:
+static struct mem_cgroup* swap_token_memcg_from_mm(struct mm_struct *mm)

total: 2 errors, 0 warnings, 40 lines checked

./patches/vmscanmemcg-memcg-aware-swap-token-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/thrash.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/thrash.c~vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes mm/thrash.c
--- a/mm/thrash.c~vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes
+++ a/mm/thrash.c
@@ -29,7 +29,7 @@ struct mem_cgroup *swap_token_memcg;
 static unsigned int global_faults;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-static struct mem_cgroup* swap_token_memcg_from_mm(struct mm_struct *mm)
+static struct mem_cgroup *swap_token_memcg_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg;
 
@@ -40,7 +40,7 @@ static struct mem_cgroup* swap_token_mem
 	return memcg;
 }
 #else
-static struct mem_cgroup* swap_token_memcg_from_mm(struct mm_struct *mm)
+static struct mem_cgroup *swap_token_memcg_from_mm(struct mm_struct *mm)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

