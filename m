Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B814C47088
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F25C3613C9
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbhEZXKw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 19:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234443AbhEZXKw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 19:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA67613B4;
        Wed, 26 May 2021 23:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622070559;
        bh=/sCYAWdduHpSEeD8xwU8O2cm4hyysGsnxJI2rjXRssA=;
        h=Date:From:To:Subject:From;
        b=cELNexAM9SwtABM+hfsY0yARcx5pPH1ftbC6ztYzEb3A3VT/QTR2TKxxzCsz12w2U
         gc4d7B+tnm3UlGbDzEGWRm+mWvHit9zNHM7De/LXo2tw09nMwp9No6hunS3QBgkPlB
         p4mZBL9v/lXyML6Mhv7eajAdF8+/2dZGQ1t8DiMQ=
Date:   Wed, 26 May 2021 16:09:19 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org,
        tpiepho@gmail.com
Subject:  + lib-math-rational-add-kunit-test-cases-fix-2.patch
 added to -mm tree
Message-ID: <20210526230919.p_MSp8IzJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/math/rational: fix spelling mistake "demominator" -> "denominator"
has been added to the -mm tree.  Its filename is
     lib-math-rational-add-kunit-test-cases-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-math-rational-add-kunit-test-cases-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-math-rational-add-kunit-test-cases-fix-2.patch

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
Subject: lib/math/rational: fix spelling mistake "demominator" -> "denominator"

There is a spelling mistake in a literal string. Fix it.

Link: https://lkml.kernel.org/r/20210526085049.6393-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Trent Piepho <tpiepho@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/rational-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/math/rational-test.c~lib-math-rational-add-kunit-test-cases-fix-2
+++ a/lib/math/rational-test.c
@@ -20,7 +20,7 @@ static const struct rational_test_param
 	{ 27,32,	16, 16,		11, 13,    "Use convergent" },
 	{ 1155, 7735,	255, 255,	33, 221,   "Exact answer" },
 	{ 87, 32,	70, 32,		68, 25,    "Semiconvergent, numerator limit" },
-	{ 14533, 4626,	15000, 2400,	7433, 2366, "Semiconvergent, demominator limit" },
+	{ 14533, 4626,	15000, 2400,	7433, 2366, "Semiconvergent, denominator limit" },
 };
 
 static void get_desc(const struct rational_test_param *param, char *desc)
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
ocfs2-remove-redundant-assignment-to-pointer-queue.patch
mm-selftests-for-exclusive-device-memory-fix.patch
lib-math-rational-add-kunit-test-cases-fix-2.patch

