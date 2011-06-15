From: akpm@linux-foundation.org
Subject: [folded] mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated-fix.patch removed from -mm tree
Date: Wed, 15 Jun 2011 15:03:00 -0700
Message-ID: <201106152203.p5FM3020022059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab1FOWDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 18:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@linux.com, mm-commits@vger.kernel.org


The patch titled
     mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated-fix.patch

This patch was dropped because it was folded into mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated-fix
From: Andrew Morton <akpm@linux-foundation.org>

standardize comment layout

Cc: Rafael Aquini <aquini@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated-fix
+++ a/mm/hugetlb.c
@@ -1111,11 +1111,11 @@ static void __init gather_bootmem_preall
 		WARN_ON(page_count(page) != 1);
 		prep_compound_huge_page(page, h->order);
 		prep_new_huge_page(h, page, page_to_nid(page));
-
-		/* if we had gigantic hugepages allocated at boot time,
-		 * we need to reinstate the 'stolen' pages to totalram_pages,
-		 * in order to fix confusing memory reports from free(1)
-		 * and another side-effects, like CommitLimit going negative.
+		/*
+		 * If we had gigantic hugepages allocated at boot time, we need
+		 * to restore the 'stolen' pages to totalram_pages in order to
+		 * fix confusing memory reports from free(1) and another
+		 * side-effects, like CommitLimit going negative.
 		 */
 		if (h->order > (MAX_ORDER - 1))
 			totalram_pages += 1 << h->order;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch
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

