Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5ECFC07E95
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 18:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B57F66135E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 18:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhGJSxz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 14:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhGJSxz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 14:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AC4061356;
        Sat, 10 Jul 2021 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625943069;
        bh=n1V2nGo6iklUvMQhHBH7y5Z9Prza9UWjGp29rC7wAOg=;
        h=Date:From:To:Subject:From;
        b=yFEPYUMLTQkLCvCfFvejvn3nBlNB1wPTbZojupbTWEOU5lIAKyj7FfGD7dICxU6PC
         0YanatsY/a93/G9NiiEBgA50nCVLj0ANphsxjYVzhYGwS6u7cuRUVa61NLNX6B7Cl3
         8bDgiImcauWC8/BUNVBGQY0XWbohgj3fRg2QbF3U=
Date:   Sat, 10 Jul 2021 11:51:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, colin.king@canonical.com
Subject:  + arch-kconfig-fix-spelling-mistake-seperate-separate.patch
 added to -mm tree
Message-ID: <20210710185109.wY9Qc%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch: Kconfig: fix spelling mistake "seperate" -> "separate"
has been added to the -mm tree.  Its filename is
     arch-kconfig-fix-spelling-mistake-seperate-separate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-kconfig-fix-spelling-mistake-seperate-separate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-kconfig-fix-spelling-mistake-seperate-separate.patch

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
Subject: arch: Kconfig: fix spelling mistake "seperate" -> "separate"

Threre is a spelling mistake in the Kconfig text. Fix it.

Link: https://lkml.kernel.org/r/20210704095207.37342-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/Kconfig~arch-kconfig-fix-spelling-mistake-seperate-separate
+++ a/arch/Kconfig
@@ -914,7 +914,7 @@ config HAVE_SOFTIRQ_ON_OWN_STACK
 	bool
 	help
 	  Architecture provides a function to run __do_softirq() on a
-	  seperate stack.
+	  separate stack.
 
 config PGTABLE_LEVELS
 	int
_

Patches currently in -mm which might be from colin.king@canonical.com are

arch-kconfig-fix-spelling-mistake-seperate-separate.patch

