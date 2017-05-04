From: akpm@linux-foundation.org
Subject: [merged] mm-swap-remove-unused-function-prototype.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:12:47 -0700
Message-ID: <20170504191247.PWEH2USVn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756505AbdEDTMt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: mm, swap: remove unused function prototype
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-unused-function-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: remove unused function prototype

This is a code cleanup patch, no functionality changes.  There are 2
unused function prototype in swap.h, they are removed.

Link: http://lkml.kernel.org/r/20170405071017.23677-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/swap.h~mm-swap-remove-unused-function-prototype include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-remove-unused-function-prototype
+++ a/include/linux/swap.h
@@ -411,9 +411,6 @@ struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
 
-extern int get_swap_slots(int n, swp_entry_t *slots);
-extern void swapcache_free_batch(swp_entry_t *entries, int n);
