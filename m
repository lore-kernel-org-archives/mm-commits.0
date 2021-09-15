Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB55C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C280B61216
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhIODc6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232165AbhIODc5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:32:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3B6161130;
        Wed, 15 Sep 2021 03:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631676699;
        bh=c3YL94gLCFamb+vei3zCHStT/h0Bv+uvNcrI9B6Hnxs=;
        h=Date:From:To:Subject:From;
        b=QlPWy0cbmD8MZZm9ygHwA9X41FMLTDn0n8CTYgKLtyEAOVDES+I7pvjyQ1eW3bCWq
         adgvRdHuh+Kxnd8A7m9MWJQkJ1xbKEf3tCnztauTKBFXBTYNk6mZSU9Wb44xrEF9JL
         dmrBhVujZlqYv0vKxTe36iwrrPP3OMlcAv0MNy2o=
Date:   Tue, 14 Sep 2021 20:31:39 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject:  + mm-damon-grammar-s-works-work.patch added to -mm tree
Message-ID: <20210915033139.fDqoBh6Dv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: grammar s/works/work/
has been added to the -mm tree.  Its filename is
     mm-damon-grammar-s-works-work.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-grammar-s-works-work.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-grammar-s-works-work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm/damon: grammar s/works/work/

Correct a singular versus plural grammar mistake in the help text for the
DAMON_VADDR config symbol.

Link: https://lkml.kernel.org/r/20210914073451.3883834-1-geert@linux-m68k.org
Fixes: 3f49584b262cf8f4 ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-grammar-s-works-work
+++ a/mm/damon/Kconfig
@@ -30,7 +30,7 @@ config DAMON_VADDR
 	select PAGE_IDLE_FLAG
 	help
 	  This builds the default data access monitoring primitives for DAMON
-	  that works for virtual address spaces.
+	  that work for virtual address spaces.
 
 config DAMON_VADDR_KUNIT_TEST
 	bool "Test for DAMON primitives" if !KUNIT_ALL_TESTS
_

Patches currently in -mm which might be from geert@linux-m68k.org are

mm-damon-grammar-s-works-work.patch

