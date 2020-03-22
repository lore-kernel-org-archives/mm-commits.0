From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
 removed from -mm tree
Date: Sat, 21 Mar 2020 18:15:42 -0700
Message-ID: <20200322011542.t9t34zCn9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCVBPo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 21:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pankaj.gupta.linux@gmail.com, richardw.yang@linux.intel.com, rppt@linux.ibm.com


The patch titled
     Subject: mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix
has been removed from the -mm tree.  Its filename was
     mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch

This patch was dropped because it was folded into mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix

remove unneeded initialization, per David

Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix
+++ a/mm/sparse.c
@@ -734,7 +734,7 @@ static void section_deactivate(unsigned
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
 	struct page *memmap = NULL;
-	bool empty = false;
+	bool empty;
 	unsigned long *subsection_map = ms->usage
 		? &ms->usage->subsection_map[0] : NULL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case.patch
drivers-infiniband-sw-siw-siw_qp_rxc-suppress-uninitialized-var-warning.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
