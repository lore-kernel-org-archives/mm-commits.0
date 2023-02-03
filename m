Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236EFC6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjBCGnp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbjBCGmK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FCD1716C
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0617A61DB0
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D488C4339B;
        Fri,  3 Feb 2023 06:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406303;
        bh=3QqKeH4HmMsN7n/qjS/tnZimKvM7m0ARFBRa2ruKqks=;
        h=Date:To:From:Subject:From;
        b=mo8swPtnlGbzLK6XDA+AauvACxyvDaqlJirNtG3AFDbX6Vht0fOr/eC2XxMpHGwP0
         W5kN3QJqDhTMzk3ZBnIuvydK8bH0hcSMhiMJRG/ldqTkqOLxJqBG7vv+vzWC7Yw7dN
         3z5lmFJv5FwrjrRE0sL+LDbNQqrCqGpL0zFSWqRg=
Date:   Thu, 02 Feb 2023 22:38:22 -0800
To:     mm-commits@vger.kernel.org, jongwooo.han@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-typo-in-comments.patch removed from -mm tree
Message-Id: <20230203063823.5D488C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup.c: fix typo in comments
has been removed from the -mm tree.  Its filename was
     mm-fix-typo-in-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


