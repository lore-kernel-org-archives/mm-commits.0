From: akpm@linux-foundation.org
Subject: + memcg-add-documentation-for-the-memorynumastat-api-fix.patch added to -mm tree
Date: Wed, 01 Jun 2011 16:16:43 -0700
Message-ID: <201106012316.p51NGhoZ015521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818Ab1FAX0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 19:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, yinghan@google.com


The patch titled
     memcg-add-documentation-for-the-memorynumastat-api-fix
has been added to the -mm tree.  Its filename is
     memcg-add-documentation-for-the-memorynumastat-api-fix.patch

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
Subject: memcg-add-documentation-for-the-memorynumastat-api-fix
From: Andrew Morton <akpm@linux-foundation.org>

rework text, fit it into 80-cols

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-add-documentation-for-the-memorynumastat-api-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-add-documentation-for-the-memorynumastat-api-fix
+++ a/Documentation/cgroups/memory.txt
@@ -467,13 +467,14 @@ value in memory.stat(see 5.2).
 
 5.6 numa_stat
 
-This is similar to numa_maps but per-memcg basis. This is useful to add visibility
-of numa locality information in memcg since the pages are allowed to be allocated
-at any physical node. One of the usecase is evaluating application performance by
-combining this information with the cpu allocation to the application.
+This is similar to numa_maps but operates on a per-memcg basis.  This is
+useful for providing visibility into the numa locality information within
+an memcg since the pages are allowed to be allocated from any physical
+node.  One of the usecases is evaluating application performance by
+combining this information with the application's cpu allocation.
 
-We export "total", "file", "anon" and "unevictable" pages per-node for each memcg.
-The format ouput of the memory.numa_stat:
+We export "total", "file", "anon" and "unevictable" pages per-node for
+each memcg.  The ouput format of memory.numa_stat is:
 
 total=<total pages> N0=<node 0 pages> N1=<node 1 pages> ...
 file=<total file pages> N0=<node 0 pages> N1=<node 1 pages> ...
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
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

