Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7532C04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 18:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbiG1SWr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiG1SW1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 14:22:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716F25B043
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 11:22:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D46261DAB
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 18:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB69C433D6;
        Thu, 28 Jul 2022 18:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659032545;
        bh=ARdGYvMwoKwIKhtxxCSIm3kO4mVOZpkr+J9lXi2+RP8=;
        h=Date:To:From:Subject:From;
        b=KkzDt5wl80mXlJiBDc9ZXLCcr3vJ39AWr5H5s0GfGTaTW31IFIQjpCmewpAkbYP6e
         7ZtEuKTNZ/4geZHkP8k3IhpHiCk2/UkIgNEXz1xk8/HvpOE3pcDS9+5I1kCozIGhVY
         qG9W8XmAqQpr3tlcL53D/ZIlRgR1wlhSNk32mWYk=
Date:   Thu, 28 Jul 2022 11:22:22 -0700
To:     mm-commits@vger.kernel.org, sophia.gabriellla@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-fix-typo.patch added to mm-unstable branch
Message-Id: <20220728182225.5CB69C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Kconfig: fix typo
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kconfig-fix-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-fix-typo.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sophia Gabriella <sophia.gabriellla@outlook.com>
Subject: mm: Kconfig: fix typo
Date: Thu, 28 Jul 2022 16:51:39 +0000

Fixes a typo in the help section for ZSWAP.

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Sophia Gabriella <sophia.gabriellla@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-fix-typo
+++ a/mm/Kconfig
@@ -33,7 +33,7 @@ config ZSWAP
 	  pages that are in the process of being swapped out and attempts to
 	  compress them into a dynamically allocated RAM-based memory pool.
 	  This can result in a significant I/O reduction on swap device and,
-	  in the case where decompressing from RAM is faster that swap device
+	  in the case where decompressing from RAM is faster than swap device
 	  reads, can also improve workload performance.
 
 	  This is marked experimental because it is a new feature (as of
_

Patches currently in -mm which might be from sophia.gabriellla@outlook.com are

mm-kconfig-fix-typo.patch

