Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50BEC6FD19
	for <mm-commits@archiver.kernel.org>; Thu,  9 Mar 2023 20:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCIUrw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Mar 2023 15:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjCIUrr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2023 15:47:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82B5FCF93
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 12:47:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DDBCB82073
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 20:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539D0C4339B;
        Thu,  9 Mar 2023 20:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678394842;
        bh=vFDBSwQnVSq4FvD1F1dimmqlq2NBVxhJbAZkCLgqhw0=;
        h=Date:To:From:Subject:From;
        b=UC+Vb5w0x6BJ+3OyvW+MKDpAf276bkeciOVPUlawI9dzM8vfR6i5Y9mPQyV7U6+SX
         XeHQ2KFSVczTdoAmIX0L/AHcXPCXb9AIBaEIEWAeOZyL8UTo5GjKvdUOu02fGmAM80
         /j9PrzeiDJo7bxjhVYqWo38XjgHu0sgwAeQzgH8s=
Date:   Thu, 09 Mar 2023 12:47:21 -0800
To:     mm-commits@vger.kernel.org, jingyuwang_vip@163.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-fix-typo-in-comments.patch added to mm-unstable branch
Message-Id: <20230309204722.539D0C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: fix typo in comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gupc-fix-typo-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-fix-typo-in-comments.patch

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
From: Jingyu Wang <jingyuwang_vip@163.com>
Subject: mm/gup.c: fix typo in comments
Date: Thu, 9 Mar 2023 18:48:13 +0800

Link: https://lkml.kernel.org/r/20230309104813.170309-1-jingyuwang_vip@163.com
Signed-off-by: Jingyu Wang <jingyuwang_vip@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-gupc-fix-typo-in-comments
+++ a/mm/gup.c
@@ -2193,7 +2193,7 @@ static bool is_valid_gup_args(struct pag
  * This does not guarantee that the page exists in the user mappings when
  * get_user_pages_remote returns, and there may even be a completely different
  * page there in some cases (eg. if mmapped pagecache has been invalidated
- * and subsequently re faulted). However it does guarantee that the page
+ * and subsequently re-faulted). However it does guarantee that the page
  * won't be freed completely. And mostly callers simply care that the page
  * contains data that was valid *at some point in time*. Typically, an IO
  * or similar operation cannot guarantee anything stronger anyway because
_

Patches currently in -mm which might be from jingyuwang_vip@163.com are

mm-gupc-fix-typo-in-comments.patch

