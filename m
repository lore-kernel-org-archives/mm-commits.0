From: akpm@linux-foundation.org
Subject: [merged] mm-writeback-remove-wb_reason_name.patch removed from
 -mm tree
Date: Tue, 09 Jul 2013 16:20:05 -0700
Message-ID: <51dc9aa5.6F0KlQS0fkicK4d0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3GIXUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, fengguang.wu@intel.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-writeback-remove-wb_reason_name.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,fengguang.wu@intel.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:05 -0700


The patch titled
     Subject: mm/writeback: remove wb_reason_name
has been removed from the -mm tree.  Its filename was
     mm-writeback-remove-wb_reason_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

