From: akpm@linux-foundation.org
Subject: [merged] checkpatch-update-copyright-dates.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:52:18 -0700
Message-ID: <200910302052.n9UKqJP5014957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932641AbZJ3Uwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: update copyright dates
has been removed from the -mm tree.  Its filename was
     checkpatch-update-copyright-dates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: update copyright dates
From: Andy Whitcroft <apw@canonical.com>

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/checkpatch.pl~checkpatch-update-copyright-dates scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-copyright-dates
+++ a/scripts/checkpatch.pl
@@ -2,7 +2,7 @@
 # (c) 2001, Dave Jones. <davej@redhat.com> (the file handling bit)
 # (c) 2005, Joel Schopp <jschopp@austin.ibm.com> (the ugly bit)
 # (c) 2007,2008, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite)
-# (c) 2008, Andy Whitcroft <apw@canonical.com>
+# (c) 2008,2009, Andy Whitcroft <apw@canonical.com>
 # Licensed under the terms of the GNU GPL License version 2
 
 use strict;
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
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
checkpatch-trivial-fix-for-trailing-statements-check.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

