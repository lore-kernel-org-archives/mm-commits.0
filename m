From: akpm@linux-foundation.org
Subject: [folded] netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:34:05 -0700
Message-ID: <20120731233405.C79FBA028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:47089 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2GaXeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:34:07 -0400
Received: by obbwc20 with SMTP id wc20so4819820obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:34:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix
has been removed from the -mm tree.  Its filename was
     netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch

This patch was dropped because it was folded into netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix

help!

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix
+++ a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -352,8 +352,6 @@ static void ixgbevf_alloc_rx_buffers(str
 				adapter->alloc_rx_buff_failed++;
 				goto no_buffers;
 			}
