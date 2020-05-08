From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 13/15] mm/vmscan: remove unnecessary argument
 description of isolate_lru_pages()
Date: Thu, 07 May 2020 18:36:20 -0700
Message-ID: <20200508013620.uczLO1OG9%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgEHBgV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 21:36:21 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, qiwuchen55@gmail.com, torvalds@linux-foundation.org

From: Qiwu Chen <qiwuchen55@gmail.com>
Subject: mm/vmscan: remove unnecessary argument description of isolate_lru_pages()

Since commit a9e7c39fa9fd9 ("mm/vmscan.c: remove 7th argument of
isolate_lru_pages()"), the explanation of 'mode' argument has been
unnecessary.  Let's remove it.

Link: http://lkml.kernel.org/r/20200501090346.2894-1-chenqiwu@xiaomi.com
Signed-off-by: Qiwu Chen <chenqiwu@xiaomi.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-remove-unnecessary-argument-description-of-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -1625,7 +1625,6 @@ static __always_inline void update_lru_s
  * @dst:	The temp list to put pages on to.
  * @nr_scanned:	The number of pages that were scanned.
  * @sc:		The scan_control struct for this reclaim session
- * @mode:	One of the LRU isolation modes
  * @lru:	LRU list id for isolating
  *
  * returns how many pages were moved onto *@dst.
_
