Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48083C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3066861424
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238320AbhGABEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238280AbhGABEz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B24861425;
        Thu,  1 Jul 2021 01:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101344;
        bh=0OMKGSu3Yh6UvNKZeRudzb1I+5kBpxzKJVlpkqt5HLs=;
        h=Date:From:To:Subject:From;
        b=tT2Wabz8pQJnjD1W+U2QmCixxghBOCqx9NRfJjC3mbwvK3gn0IrHF4VhSgfHiZdPG
         VnCx3ftvVdbFwNB1chcjvoZIFzxtS9MUvSTVaJIyhzUKEI74Kerl11qZoIygGkn29b
         qwuyrR7qVwe6T34uADsibALRSBBQQPMEuC/Jm7QE=
Date:   Wed, 30 Jun 2021 18:02:24 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org,
        tpiepho@gmail.com
Subject:  [folded-merged]
 lib-math-rational-add-kunit-test-cases-fix-2.patch removed from -mm tree
Message-ID: <20210701010224.0EBC4qHXp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/math/rational: fix spelling mistake "demominator" -> "denominator"
has been removed from the -mm tree.  Its filename was
     lib-math-rational-add-kunit-test-cases-fix-2.patch

This patch was dropped because it was folded into lib-math-rational-add-kunit-test-cases.patch

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
ocfs2-remove-redundant-initialization-of-variable-ret.patch
lib-math-rational-add-kunit-test-cases.patch
nilfs2-remove-redundant-continue-statement-in-a-while-loop.patch

