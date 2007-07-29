From: akpm@linux-foundation.org
Subject: - slab-maintainer-credits-update.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:09 -0700
Message-ID: <200707290611.l6T6B9lp010965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756738AbXG2GLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Slab maintainer & Credits update
has been removed from the -mm tree.  Its filename was
     slab-maintainer-credits-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Slab maintainer & Credits update
From: Christoph Lameter <clameter@sgi.com>

Slab maintainer & Credits update

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    5 +++--
 MAINTAINERS |    8 ++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN CREDITS~slab-maintainer-credits-update CREDITS
--- a/CREDITS~slab-maintainer-credits-update
+++ a/CREDITS
@@ -966,6 +966,7 @@ N: Pekka Enberg
 E: penberg@cs.helsinki.fi
 W: http://www.cs.helsinki.fi/u/penberg/
 D: Various kernel hacks, fixes, and cleanups.
+D: Slab allocators
 S: Finland
 
 N: David Engebretsen
@@ -1939,8 +1940,8 @@ D: for Menuconfig's lxdialog.
 N: Christoph Lameter
 E: christoph@lameter.com
 D: Digiboard PC/Xe and PC/Xi, Digiboard EPCA
-D: Early protocol filter for bridging code
-D: Bug fixes
+D: NUMA support, Slab allocators, Page migration
+D: Scalability, Time subsystem
 
 N: Paul Laufer
 E: paul@laufernet.com
diff -puN MAINTAINERS~slab-maintainer-credits-update MAINTAINERS
--- a/MAINTAINERS~slab-maintainer-credits-update
+++ a/MAINTAINERS
@@ -3339,6 +3339,14 @@ M:	thomas@winischhofer.net
 W:	http://www.winischhofer.at/linuxsisusbvga.shtml
 S:	Maintained
 
+SLAB ALLOCATOR
+P:	Christoph Lameter
+M:	clameter@sgi.com
+P:	Pekka Enberg
+M:	penberg@cs.helsinki.fi
+L:	linux-mm@kvack.org
+S:	Maintained
+
 SMC91x ETHERNET DRIVER
 P:	Nicolas Pitre
 M:	nico@cam.org
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-add-lock-debugging-check.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
x86_64-family-10h-and-11h-to-k8topology.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
slub-fix-bug-in-slub-debug-support.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
page-owner-tracking-leak-detector.patch
