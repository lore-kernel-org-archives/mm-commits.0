From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 khugepaged-introduce-max_ptes_shared-tunable-fix.patch removed from -mm
 tree
Date: Wed, 03 Jun 2020 15:14:37 -0700
Message-ID: <20200603221437.ZFEIUtAAC%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgFCWOi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:14:38 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: khugepaged: fix several spelling mistakes
has been removed from the -mm tree.  Its filename was
     khugepaged-introduce-max_ptes_shared-tunable-fix.patch

This patch was dropped because it was folded into khugepaged-introduce-max_ptes_shared-tunable.patch

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: selftests: khugepaged: fix several spelling mistakes

There are three spelling mistakes in various messages. Fix these.

Link: http://lkml.kernel.org/r/20200420084241.65433-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/khugepaged.c~khugepaged-introduce-max_ptes_shared-tunable-fix
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -961,7 +961,7 @@ static void collapse_max_ptes_shared()
 		else
 			fail("Fail");
 
-		if (wait_for_scan("Do not collapse with max_ptes_shared exeeded", p))
+		if (wait_for_scan("Do not collapse with max_ptes_shared exceeded", p))
 			fail("Timeout");
 		else if (!check_huge(p))
 			success("OK");
_

Patches currently in -mm which might be from colin.king@canonical.com are

khugepaged-introduce-max_ptes_shared-tunable.patch
