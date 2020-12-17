Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE99C4361B
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E83239EB
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgLQXDz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 18:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbgLQXDz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 18:03:55 -0500
Date:   Thu, 17 Dec 2020 15:02:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608246164;
        bh=tGDsPR1S30qFKALEwQ5pyPIcNkz23L5OTY7W96nr7fw=;
        h=From:To:Subject:From;
        b=i10KlcLTQApTM7YrOkuoY1pdaU+PcvWsyaOa0Q9NPAxL6eoXS8fYB26gSHkhvrP9g
         cP6li2YdOHP/NZj101JXQ8t6blsPA/4c5yGOGl6coWiQzj7jpp1DjN2R3TSwGsIP5R
         hf9UihE3TqekgUomWyPRTsNit1Psq0xS7SsOvHxc=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        andriy.shevchenko@linux.intel.com
Subject:  [to-be-updated]
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch removed
 from -mm tree
Message-ID: <20201217230244.5Mbx3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline_kunit: provide meaningful MODULE_LICENSE()
has been removed from the -mm tree.  Its filename was
     lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/cmdline_kunit: provide meaningful MODULE_LICENSE()

modpost complains that module has no licence provided.  Provide it via
meaningful MODULE_LICENSE().

Link: https://lkml.kernel.org/r/20201116104257.15527-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline_kunit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/cmdline_kunit.c~lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3
+++ a/lib/cmdline_kunit.c
@@ -96,3 +96,5 @@ static struct kunit_suite cmdline_test_s
 	.test_cases = cmdline_test_cases,
 };
 kunit_test_suite(cmdline_test_suite);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-mathematical-helpers.patch
bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch
apparmor-remove-duplicate-macro-list_entry_is_head.patch

