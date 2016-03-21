From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-unnecessary-description-about-a-non-exist-gfp-flag.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:39:29 -0700
Message-ID: <56f03fe1.tR7EMLfMpDiM0Q7Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbcCUT42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takeuchi_satoru@jp.fujitsu.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unnecessary description about a non-exist gfp flag
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-description-about-a-non-exist-gfp-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: mm: remove unnecessary description about a non-exist gfp flag

Since __GFP_NOACCOUNT is removed by the following commit,
its description is not necessary.

commit 20b5c3039863 ("Revert 'gfp: add __GFP_NOACCOUNT'")

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/gfp.h~mm-remove-unnecessary-description-about-a-non-exist-gfp-flag include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-unnecessary-description-about-a-non-exist-gfp-flag
+++ a/include/linux/gfp.h
@@ -105,8 +105,6 @@ struct vm_area_struct;
  *
  * __GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
  *   This takes precedence over the __GFP_MEMALLOC flag if both are set.
- *
- * __GFP_NOACCOUNT ignores the accounting for kmemcg limit enforcement.
  */
 #define __GFP_ATOMIC	((__force gfp_t)___GFP_ATOMIC)
 #define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)
_

Patches currently in -mm which might be from takeuchi_satoru@jp.fujitsu.com are


