Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B8DC2BBCF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2A9823A51
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgLQXDz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 18:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730140AbgLQXDz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 18:03:55 -0500
Date:   Thu, 17 Dec 2020 15:02:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608246162;
        bh=XpT2M5mYIV4CAhDWk1a2sbFHCLjR1CrHqk8qEB2PFgA=;
        h=From:To:Subject:From;
        b=TfmtfKzHr+0/plbrKkFoePskSdhTLj6S9ByabpJ1yOsalwMC/RksTi33UTLpnANVa
         2aD8ncvGZEb1PRxtXlKb8x1RHRVf3psIMx9oYm7no+LvfLSWVNwKubrIi05gnbYwVO
         N2/brQa4uOgceHE3YzJ1oQ+foRm2xbAs/QKlh3D8=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject:  [to-be-updated]
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-2.patch removed
 from -mm tree
Message-ID: <20201217230242.MMbhQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline_kunit: type of expected returned values should be int
has been removed from the -mm tree.  Its filename was
     lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/cmdline_kunit: type of expected returned values should be int

Type of expected returned values should be int.

Link: https://lkml.kernel.org/r/20201116104244.15472-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline_kunit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/cmdline_kunit.c~lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-2
+++ a/lib/cmdline_kunit.c
@@ -13,7 +13,7 @@ static const char *cmdline_test_strings[
 	"+,"  , "--", ",,", "''" , "\"\",", "\",\"", "-\"\"", "\"",
 };
 
-static const char cmdline_test_values[] = {
+static const int cmdline_test_values[] = {
 	1, 1, 1, 1, 2, 3, 2, 3,
 	1, 3, 2, 1, 1, 1, 3, 1,
 };
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-mathematical-helpers.patch
bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch
apparmor-remove-duplicate-macro-list_entry_is_head.patch

