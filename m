From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 09 May 2016 11:34:52 -0700
Message-ID: <5730d84c.UHuBRPlCfpmUaoyV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbcEISey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 14:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/boot/dts/renesas/r8a7795.dtsi |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/input/misc/twl6040-vibra.c~linux-next-git-rejects drivers/input/misc/twl6040-vibra.c
diff -puN arch/arm64/boot/dts/renesas/r8a7795.dtsi~linux-next-git-rejects arch/arm64/boot/dts/renesas/r8a7795.dtsi
--- a/arch/arm64/boot/dts/renesas/r8a7795.dtsi~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/renesas/r8a7795.dtsi
@@ -134,8 +134,6 @@
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <0>;
-<<<<<<< HEAD
-=======
 	};
 
 	/* External PCIe clock - can be overridden by the board */
@@ -143,7 +141,6 @@
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <0>;
->>>>>>> linux-next/akpm-base
 	};
 
 	soc {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

