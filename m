From: akpm@linux-foundation.org
Subject: + bits-add-tests-of-genmask-fix.patch added to -mm tree
Date: Thu, 25 Jun 2020 13:17:22 -0700
Message-ID: <20200625201722.I2fIA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407101AbgFYURY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 16:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com, andy.shevchenko@gmail.com, rd.dunlap@gmail.com


The patch titled
     Subject: lib/test_bits: add MODULE_LICENSE()
has been added to the -mm tree.  Its filename is
     bits-add-tests-of-genmask-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bits-add-tests-of-genmask-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bits-add-tests-of-genmask-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rd.dunlap@gmail.com>
Subject: lib/test_bits: add MODULE_LICENSE()

Add MODULE_LICENSE() to prevent build warning:

WARNING: modpost: missing MODULE_LICENSE() in lib/test_bits.o

Link: http://lkml.kernel.org/r/dfc74524-0789-2827-4eff-476ddab65699@gmail.com
Signed-off-by: Randy Dunlap <rd.dunlap@gmail.com>
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bits.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_bits.c~bits-add-tests-of-genmask-fix
+++ a/lib/test_bits.c
@@ -71,3 +71,5 @@ static struct kunit_suite bits_test_suit
 	.test_cases = bits_test_cases,
 };
 kunit_test_suite(bits_test_suite);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from rd.dunlap@gmail.com are

bits-add-tests-of-genmask-fix.patch
