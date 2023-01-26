Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE879C27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbjAZAp7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbjAZAp6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:45:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351715DC04
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:45:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4DF0616C6
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAC0C433EF;
        Thu, 26 Jan 2023 00:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674693956;
        bh=qD3mdzjmd2qU22jvCJ9IuXMcmls2/1+O4G/BwWgPOmw=;
        h=Date:To:From:Subject:From;
        b=pPislK2GcX2HvBJFx3uNlqZBKs9rXhjaI8Pn2845f0PVyWK6gGZODh8KNXluDBoRN
         5LcZwZ1GQGjXloFMXsWJzV8PtaMu/GzIaj1+7/2yB+FC2oxq10yf1M3Rssy9g4vVNx
         1TyU4izI2243eE6tJjr9DW76QuMSTaShaAFFgB+4=
Date:   Wed, 25 Jan 2023 16:45:55 -0800
To:     mm-commits@vger.kernel.org, jongwooo.han@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-typo-in-comments.patch added to mm-unstable branch
Message-Id: <20230126004556.1FAC0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: fix typo in comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-typo-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-typo-in-comments.patch

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
From: Jongwoo Han <jongwooo.han@gmail.com>
Subject: mm/gup.c: fix typo in comments
Date: Thu, 26 Jan 2023 03:08:47 +0900

Link: https://lkml.kernel.org/r/20230125180847.4542-1-jongwooo.han@gmail.com
Signed-off-by: Jongwoo Han <jongwooo.han@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-fix-typo-in-comments
+++ a/mm/gup.c
@@ -1055,7 +1055,7 @@ static int check_vma_flags(struct vm_are
  * This does not guarantee that the page exists in the user mappings when
  * __get_user_pages returns, and there may even be a completely different
  * page there in some cases (eg. if mmapped pagecache has been invalidated
- * and subsequently re faulted). However it does guarantee that the page
+ * and subsequently re-faulted). However it does guarantee that the page
  * won't be freed completely. And mostly callers simply care that the page
  * contains data that was valid *at some point in time*. Typically, an IO
  * or similar operation cannot guarantee anything stronger anyway because
_

Patches currently in -mm which might be from jongwooo.han@gmail.com are

mm-fix-typo-in-comments.patch

