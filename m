From: akpm@linux-foundation.org
Subject: + mm-swap-remove-unused-function-prototype.patch added to -mm
 tree
Date: Thu, 06 Apr 2017 16:11:57 -0700
Message-ID: <58e6cb3d.CwcPava8lYJaQH+z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932527AbdDFXL6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 19:11:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: Remove unused function prototype
has been added to the -mm tree.  Its filename is
     mm-swap-remove-unused-function-prototype.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-remove-unused-function-prototype.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-remove-unused-function-prototype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: Remove unused function prototype

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
