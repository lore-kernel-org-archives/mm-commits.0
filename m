From: akpm@linux-foundation.org
Subject: [merged] slab-use-numa_no_node.patch removed from -mm tree
Date: Mon, 01 Aug 2011 11:49:36 -0700
Message-ID: <201108011847.p71IlSK8005637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878Ab1HASro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 14:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slab: use NUMA_NO_NODE
has been removed from the -mm tree.  Its filename was
     slab-use-numa_no_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slab: use NUMA_NO_NODE
From: Andrew Morton <akpm@linux-foundation.org>

Use the nice enumerated constant.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-use-numa_no_node mm/slab.c
--- a/mm/slab.c~slab-use-numa_no_node
+++ a/mm/slab.c
@@ -3403,7 +3403,7 @@ __cache_alloc_node(struct kmem_cache *ca
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
-	if (nodeid == -1)
+	if (nodeid == NUMA_NO_NODE)
 		nodeid = slab_node;
 
 	if (unlikely(!cachep->nodelists[nodeid])) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

