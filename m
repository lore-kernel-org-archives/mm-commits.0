From: akpm@linux-foundation.org
Subject: + hardware-latency-detector-remove-default-m.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:50:52 -0700
Message-ID: <200910162150.n9GLoqjk002022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbZJPVvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, jcm@jonmasters.org


The patch titled
     hardware latency detector: remove "default m"
has been added to the -mm tree.  Its filename is
     hardware-latency-detector-remove-default-m.patch

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
Subject: hardware latency detector: remove "default m"
From: Andi Kleen <andi@firstfloor.org>

No reason at all why this should be default anything except n.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jon Masters <jcm@jonmasters.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/misc/Kconfig~hardware-latency-detector-remove-default-m drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~hardware-latency-detector-remove-default-m
+++ a/drivers/misc/Kconfig
@@ -80,7 +80,6 @@ config HWLAT_DETECTOR
 	tristate "Testing module to detect hardware-induced latencies"
 	depends on DEBUG_FS
 	depends on RING_BUFFER
-	default m
 	---help---
 	  A simple hardware latency detector. Use this module to detect
 	  large latencies introduced by the behavior of the underlying
_

Patches currently in -mm which might be from andi@firstfloor.org are

hwpoison-fix-oops-on-ksm-pages.patch
hwpoison-fix-proc-meminfo-alignment.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

