Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E688DC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 03:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A380023444
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 03:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731962AbgLRDZN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 22:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728179AbgLRDZN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 22:25:13 -0500
Date:   Thu, 17 Dec 2020 19:24:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608261872;
        bh=bA/Ftjw4hUQ16sp2TtE2OAiWL77NdbK0pfv7vp6h8xI=;
        h=From:To:Subject:From;
        b=1Kjtp6BOa6PQPdVWuCLyW2pDPL39b16sBgpBhvE0cx4IwWx7Odrr/5qzOvJnLBXZP
         +CyiRnIao0fx+83VLQutZoZxDB1SvTcmbKK6eVeQo1I2Nr8laGThWubouVaL/pdfwP
         b330Wl4l2hovbP7RO7y7tjK0HPo+8ndWMjYS7mRw=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, colin.king@canonical.com
Subject:  + mm-fix-spelling-mistake-in-kconfig-whats-whats.patch
 added to -mm tree
Message-ID: <20201218032432.Tq0sV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: fix spelling mistake "whats" -> "what's"
has been added to the -mm tree.  Its filename is
     mm-fix-spelling-mistake-in-kconfig-whats-whats.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-spelling-mistake-in-kconfig-whats-whats.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-spelling-mistake-in-kconfig-whats-whats.patch

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
Subject: mm/Kconfig: fix spelling mistake "whats" -> "what's"

There is a spelling mistake in the Kconfig help text. Fix it.

Link: https://lkml.kernel.org/r/20201217172717.58203-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-fix-spelling-mistake-in-kconfig-whats-whats
+++ a/mm/Kconfig
@@ -713,7 +713,7 @@ config ZSMALLOC_STAT
 	select DEBUG_FS
 	help
 	  This option enables code in the zsmalloc to collect various
-	  statistics about whats happening in zsmalloc and exports that
+	  statistics about what's happening in zsmalloc and exports that
 	  information to userspace via debugfs.
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-fix-spelling-mistake-in-kconfig-whats-whats.patch

