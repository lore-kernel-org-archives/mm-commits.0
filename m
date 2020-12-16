Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B18EC0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B1F2311B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgLPEK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPEK1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:10:27 -0500
Date:   Tue, 15 Dec 2020 20:09:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608091786;
        bh=LWnrWjqg23q/9QZtqKFV+DMT7TBAJm4xkfpie1gJqfg=;
        h=From:To:Subject:From;
        b=t7hbpt71LI8w0//0LQKgR1ylDj8qNJ+amOR7F/R6D9MUzm6rDYfMeEAOkppgFIRc2
         SBJXfyPIHfpyaYGYgZ/VpMI9tAoAcPFNAtNK8yugS4H5cgBy6zzLOcJrkL75OXr6N+
         NT1RAc/P3/QuZPnrDi3tMpwISrpBwvbpFcLLEO+o=
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch removed
 from -mm tree
Message-ID: <20201216040946.aT-fSIA99%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline_kunit: provide meaningful MODULE_LICENSE()
has been removed from the -mm tree.  Its filename was
     lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch

This patch was dropped because it was folded into lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch

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
lib-list_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-linear_ranges_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-bits_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch
lib-cmdline-allow-null-to-be-an-output-for-get_option.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch
apparmor-remove-duplicate-macro-list_entry_is_head.patch

