From: akpm@linux-foundation.org
Subject: + checkpatch-update-copyright-dates.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:06:53 -0700
Message-ID: <200910162106.n9GL6rEu004676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbZJPVGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: update copyright dates
has been added to the -mm tree.  Its filename is
     checkpatch-update-copyright-dates.patch

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

checkpatch-possible-types-prevent-illegal-modifiers-being-added.patch
checkpatch-correctly-stop-scanning-at-the-bottom-of-a-hunk.patch
checkpatch-update-copyright-dates.patch
checkpatch-fix-false-errors-due-to-macro-concatenation.patch
checkpatch-fix-__attribute__-matching.patch
checkpatch-fix-false-export_symbol-warning.patch
checkpatch-version-030.patch
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

