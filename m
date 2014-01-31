From: akpm@linux-foundation.org
Subject: [folded-merged]
 swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
 removed from -mm tree
Date: Fri, 31 Jan 2014 12:36:56 -0800
Message-ID: <52ec0968.X8gdOzw63hd3Kj42%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbaAaUg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 15:36:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@kernel.org, hannes@cmpxchg.org, fengguang.wu@intel.com

Subject: [folded-merged] swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch removed from -mm tree
To: fengguang.wu@intel.com,hannes@cmpxchg.org,shli@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 12:36:56 -0800


The patch titled
     Subject: swap: swapin_nr_pages() can be static
has been removed from the -mm tree.  Its filename was
     swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

This patch was dropped because it was folded into swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: swap: swapin_nr_pages() can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_state.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix mm/swap_state.c
--- a/mm/swap_state.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
+++ a/mm/swap_state.c
@@ -394,7 +394,7 @@ struct page *read_swap_cache_async(swp_e
 	return found_page;
 }
 
-unsigned long swapin_nr_pages(unsigned long offset)
+static unsigned long swapin_nr_pages(unsigned long offset)
 {
 	static unsigned long prev_offset;
 	unsigned int pages, max_pages, last_ra;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch
debugging-keep-track-of-page-owners.patch

