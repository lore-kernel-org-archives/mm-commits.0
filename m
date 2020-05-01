From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-vmscan-remove-unnecessary-argument-description-of-isolate?=
 =?US-ASCII?Q?=5Flru=5Fpages.patch?= added to -mm tree
Date: Fri, 01 May 2020 14:42:02 -0700
Message-ID: <20200501214202.qyUPx-T_-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgEAVmD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 May 2020 17:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, mm-commits@vger.kernel.org, qiwuchen55@gmail.com


The patch titled
     Subject: mm/vmscan: remove unnecessary argument description of isolate_lru_pages()
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-unnecessary-argument-description-of-isolate_lru_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-unnecessary-argument-description-of-isolate_lru_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-unnecessary-argument-description-of-isolate_lru_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from qiwuchen55@gmail.com are

mm-vmscan-remove-unnecessary-argument-description-of-isolate_lru_pages.patch
