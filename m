From: akpm@linux-foundation.org
Subject: +
 es-khugepaged-introduce-max_ptes_shared-tunable-fix.patch added to -mm tree
Date: Mon, 20 Apr 2020 14:41:31 -0700
Message-ID: <20200420214131.PEtBm5MlT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgDTVld (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 17:41:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: khugepaged: fix several spelling mistakes
has been added to the -mm tree.  Its filename is
     es-khugepaged-introduce-max_ptes_shared-tunable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/es-khugepaged-introduce-max_ptes_shared-tunable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/es-khugepaged-introduce-max_ptes_shared-tunable-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: selftests: khugepaged: fix several spelling mistakes

There a are several spelling mistakes in various messages. Fix these.

There are three spelling mistakes in various messages. Fix these.

Link: http://lkml.kernel.org/r/20200420084241.65433-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/khugepaged.c~es-khugepaged-introduce-max_ptes_shared-tunable-fix
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -908,7 +908,7 @@ static void collapse_max_ptes_shared()
 		else
 			fail("Fail");
 
-		if (wait_for_scan("Do not collapse with max_ptes_shared exeeded", p))
+		if (wait_for_scan("Do not collapse with max_ptes_shared exceeded", p))
 			fail("Timeout");
 		else if (!check_huge(p))
 			success("OK");
_

Patches currently in -mm which might be from colin.king@canonical.com are

khugepaged-add-self-test-fix.patch
es-khugepaged-introduce-max_ptes_shared-tunable-fix.patch
