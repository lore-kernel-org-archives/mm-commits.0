Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FB9C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 20:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D87D64F9B
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 20:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbhBYUPz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 15:15:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233732AbhBYUPo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 15:15:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA03264F2B;
        Thu, 25 Feb 2021 20:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614284104;
        bh=/OgAdc2nF1QhnhvmMcmcVvkZv4zWvu2wWVT5VwDAAEM=;
        h=Date:From:To:Subject:From;
        b=Yy09XsvSN2AacdtclbPrau19b/8QpF7vzYCrA8lyIskx67oa3IGwq3BFaXgduiBRf
         2HJE5s3z4NTrAzONeoDwQ4wqfrOFIqTnLB2euBlIzzYn0sWKMVVWM1RP1wQBLyu6r5
         GXt6TEkbzYV7r8moGfak0HWev162Y7GQmD1S1GIM=
Date:   Thu, 25 Feb 2021 12:15:03 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, nathan@kernel.org,
        rdunlap@infradead.org, unixbhaskar@gmail.com
Subject:  +
 init-kconfig-fix-a-typo-in-cc_version_text-help-text.patch added to -mm
 tree
Message-ID: <20210225201503.th1VDfG8H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: fix a typo in CC_VERSION_TEXT help text
has been added to the -mm tree.  Its filename is
     init-kconfig-fix-a-typo-in-cc_version_text-help-text.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-kconfig-fix-a-typo-in-cc_version_text-help-text.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-kconfig-fix-a-typo-in-cc_version_text-help-text.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: init/Kconfig: fix a typo in CC_VERSION_TEXT help text

s/compier/compiler/

Link: https://lkml.kernel.org/r/20210224223325.29099-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig~init-kconfig-fix-a-typo-in-cc_version_text-help-text
+++ a/init/Kconfig
@@ -19,7 +19,7 @@ config CC_VERSION_TEXT
 	    CC_VERSION_TEXT so it is recorded in include/config/auto.conf.cmd.
 	    When the compiler is updated, Kconfig will be invoked.
 
-	  - Ensure full rebuild when the compier is updated
+	  - Ensure full rebuild when the compiler is updated
 	    include/linux/kconfig.h contains this option in the comment line so
 	    fixdep adds include/config/cc/version/text.h into the auto-generated
 	    dependency. When the compiler is updated, syncconfig will touch it
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are

init-kconfig-fix-a-typo-in-cc_version_text-help-text.patch

