Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B53C77B60
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjC1XW6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjC1XWE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FE935B7
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 837EF619F9
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0403C433EF;
        Tue, 28 Mar 2023 23:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045719;
        bh=PE3WhA6r75Nau1y+iSm24wF9N9d6evoKr9BmJrwivN8=;
        h=Date:To:From:Subject:From;
        b=GKrVrpHyFAKvscJ3jHfGl6jpuZP1AB6OpYyKEK93ntrWAgNZJ1cKn84UJl4PxKdXU
         bKwOmbg1TdRCwYXQLZU0h1XZCP1BH5qMxqFOQ0u9DcEzu9E3nBGnu2HOyHjBRgNlZX
         7p4QACIepDQPawqJqbT1y04WjeAXYVVCjoHX+V6U=
Date:   Tue, 28 Mar 2023 16:21:58 -0700
To:     mm-commits@vger.kernel.org, jingyuwang_vip@163.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gupc-fix-typo-in-comments.patch removed from -mm tree
Message-Id: <20230328232158.E0403C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup.c: fix typo in comments
has been removed from the -mm tree.  Its filename was
     mm-gupc-fix-typo-in-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jingyu Wang <jingyuwang_vip@163.com>
Subject: mm/gup.c: fix typo in comments
Date: Thu, 9 Mar 2023 18:48:13 +0800

Link: https://lkml.kernel.org/r/20230309104813.170309-1-jingyuwang_vip@163.com
Signed-off-by: Jingyu Wang <jingyuwang_vip@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


