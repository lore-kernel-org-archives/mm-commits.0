From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch removed
 from -mm tree
Date: Thu, 14 Jan 2016 14:38:36 -0800
Message-ID: <5698236c.obbf0/p0OBqMUSCN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbcANWii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:38:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch

This patch was dropped because it was folded into mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix

>
> While at it - you would also want to nuke
>
> Documentation/features/vm/pmdp_splitting_flush/

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/features/vm/pmdp_splitting_flush/arch-support.txt |   40 ----------
 1 file changed, 40 deletions(-)

diff -puN Documentation/features/vm/pmdp_splitting_flush/arch-support.txt~mm-thp-remove-infrastructure-for-handling-splitting-pmds-fix /dev/null
--- a/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
+++ /dev/null
@@ -1,40 +0,0 @@
-#
-# Feature name:          pmdp_splitting_flush
-#         Kconfig:       __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-#         description:   arch supports the pmdp_splitting_flush() VM API
-#
-    -----------------------
-    |         arch |status|
-    -----------------------
-    |       alpha: | TODO |
-    |         arc: | TODO |
-    |         arm: |  ok  |
-    |       arm64: |  ok  |
-    |       avr32: | TODO |
-    |    blackfin: | TODO |
-    |         c6x: | TODO |
-    |        cris: | TODO |
-    |         frv: | TODO |
-    |       h8300: | TODO |
-    |     hexagon: | TODO |
-    |        ia64: | TODO |
-    |        m32r: | TODO |
-    |        m68k: | TODO |
-    |       metag: | TODO |
-    |  microblaze: | TODO |
-    |        mips: |  ok  |
-    |     mn10300: | TODO |
-    |       nios2: | TODO |
-    |    openrisc: | TODO |
-    |      parisc: | TODO |
-    |     powerpc: |  ok  |
-    |        s390: |  ok  |
-    |       score: | TODO |
-    |          sh: | TODO |
-    |       sparc: | TODO |
-    |        tile: | TODO |
-    |          um: | TODO |
-    |   unicore32: | TODO |
-    |         x86: |  ok  |
-    |      xtensa: | TODO |
-    -----------------------
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch
thp-reintroduce-split_huge_page-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch
thp-increase-split_huge_page-success-rate-fix.patch
mm-add-page_check_address_transhuge-helper-fix-fix.patch

