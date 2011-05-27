From: akpm@linux-foundation.org
Subject: [folded] cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:38 -0700
Message-ID: <201105272035.p4RKZRkb019625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab1E0Ufa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited before that close parenthesis ')'
#28: FILE: include/linux/nodemask.h:436:
+unsigned int get_random_int(void );

total: 1 errors, 0 warnings, 43 lines checked

./patches/cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-checkpatch-fixes include/linux/nodemask.h
--- a/include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-checkpatch-fixes
+++ a/include/linux/nodemask.h
@@ -433,7 +433,7 @@ static inline void node_set_offline(int 
 	nr_online_nodes = num_node_state(N_ONLINE);
 }
 
-unsigned int get_random_int(void );
+unsigned int get_random_int(void);
 /*
  * Return the bit number of a random bit set in the nodemask.
  * (returns -1 if nodemask is empty)
diff -puN mm/mempolicy.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-checkpatch-fixes mm/mempolicy.c
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
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch
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

