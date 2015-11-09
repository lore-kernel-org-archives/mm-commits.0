From: akpm@linux-foundation.org
Subject: [obsolete] net-ipv4-routec-prevent-oops.patch removed from -mm
 tree
Date: Mon, 09 Nov 2015 12:14:03 -0800
Message-ID: <5640fe8b.xU4E/1uegcvUYeW9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbKIUOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:14:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: net/ipv4/route.c: prevent oops
has been removed from the -mm tree.  Its filename was
     net-ipv4-routec-prevent-oops.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net/ipv4/route.c: prevent oops

Fix oops in ip_route_input_slow()

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/route.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN net/ipv4/route.c~net-ipv4-routec-prevent-oops net/ipv4/route.c
--- a/net/ipv4/route.c~net-ipv4-routec-prevent-oops
+++ a/net/ipv4/route.c
@@ -1740,6 +1740,8 @@ static int ip_route_input_slow(struct sk
 	struct net    *net = dev_net(dev);
 	bool do_cache;
 
+	res.table = 0;
+
 	/* IP on this device is disabled. */
 
 	if (!in_dev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

