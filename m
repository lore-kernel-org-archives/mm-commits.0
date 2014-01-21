From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-overcommit_kbytes-sysctl-variable-fix.patch removed from -mm tree
Date: Tue, 21 Jan 2014 15:30:37 -0800
Message-ID: <52df031d.9p/CG2Vb/FndtIw4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaAUXai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:30:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmarchan@redhat.com, dave.hansen@linux.intel.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org

Subject: [folded-merged] mm-add-overcommit_kbytes-sysctl-variable-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,alan@lxorguk.ukuu.org.uk,dave.hansen@linux.intel.com,jmarchan@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:30:37 -0800


The patch titled
     Subject: mm-add-overcommit_kbytes-sysctl-variable-fix
has been removed from the -mm tree.  Its filename was
     mm-add-overcommit_kbytes-sysctl-variable-fix.patch

This patch was dropped because it was folded into mm-add-overcommit_kbytes-sysctl-variable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-overcommit_kbytes-sysctl-variable-fix

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-add-overcommit_kbytes-sysctl-variable-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-add-overcommit_kbytes-sysctl-variable-fix
+++ a/Documentation/sysctl/vm.txt
@@ -581,7 +581,7 @@ When overcommit_memory is set to 2, the
 permitted to exceed swap plus this amount of physical RAM. See below.
 
 Note: overcommit_kbytes is the counterpart of overcommit_ratio. Only one
-of them may be specified at a time. Setting one disable the other (which
+of them may be specified at a time. Setting one disables the other (which
 then appears as 0 when read).
 
 ==============================================================
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
posix_acl-uninlining.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-add-overcommit_kbytes-sysctl-variable.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

