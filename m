From: akpm@linux-foundation.org
Subject: + mm-writeback-remove-wb_reason_name.patch added to -mm tree
Date: Tue, 25 Jun 2013 15:23:46 -0700
Message-ID: <51ca1872.NmE/b6CHHOk0Do9o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3FYWXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 18:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, fengguang.wu@intel.com, liwanp@linux.vnet.ibm.com

Subject: + mm-writeback-remove-wb_reason_name.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,fengguang.wu@intel.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 15:23:46 -0700


The patch titled
     Subject: mm/writeback: remove wb_reason_name
has been added to the -mm tree.  Its filename is
     mm-writeback-remove-wb_reason_name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/writeback: remove wb_reason_name

wb_reason_name is not used any more - remove it.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/writeback.h~mm-writeback-remove-wb_reason_name include/linux/writeback.h
--- a/include/linux/writeback.h~mm-writeback-remove-wb_reason_name
+++ a/include/linux/writeback.h
@@ -51,7 +51,6 @@ enum wb_reason {
 
 	WB_REASON_MAX,
 };
-extern const char *wb_reason_name[];
 
 /*
  * A control structure which tells the writeback code what to do.  These are
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix.patch
mm-pageblock-remove-get-set_pageblock_flags.patch
mm-hugetlb-remove-hugetlb_prefault.patch
mm-hugetlb-use-already-exist-interface-huge_page_shift.patch
mm-writeback-remove-wb_reason_name.patch
mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch
mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch
mm-page_alloc-fix-doc-for-numa_zonelist_order.patch
mm-thp-fix-doc-for-transparent-huge-zero-page.patch
mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch

