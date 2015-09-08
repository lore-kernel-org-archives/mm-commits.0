From: akpm@linux-foundation.org
Subject: [folded-merged] pagemap-update-documentation-fix.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 14:36:56 -0700
Message-ID: <55ef54f8.wT3GxZHx1lwdOBvo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbbIHVg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khlebnikov@yandex-team.ru, mwilliamson@undo-software.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap-update-documentation-fix
has been removed from the -mm tree.  Its filename was
     pagemap-update-documentation-fix.patch

This patch was dropped because it was folded into pagemap-update-documentation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pagemap-update-documentation-fix

various tweaks

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mark Williamson <mwilliamson@undo-software.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/pagemap.txt~pagemap-update-documentation-fix Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-update-documentation-fix
+++ a/Documentation/vm/pagemap.txt
@@ -22,9 +22,9 @@ There are three components to pagemap:
     * Bit  62    page swapped
     * Bit  63    page present
 
-   Since Linux 4.0 only users with the CAP_SYS_ADMIN capability can get PFNs:
-   for unprivileged users from 4.0 till 4.2 open fails with -EPERM, starting
-   from from 4.2 PFN field is zeroed if user has no CAP_SYS_ADMIN capability.
+   Since Linux 4.0 only users with the CAP_SYS_ADMIN capability can get PFNs.
+   In 4.0 and 4.1 opens by unprivileged fail with -EPERM.  Starting from
+   4.2 the PFN field is zeroed if the user does not have CAP_SYS_ADMIN.
    Reason: information about PFNs helps in exploiting Rowhammer vulnerability.
 
    If the page is not present but in swap, then the PFN contains an
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

dax-revert-userfaultfd-change.patch
pagemap-update-documentation.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch

