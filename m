Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1D5C43334
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiFZUWg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiFZUWf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:22:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9273C5B
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91CEBB80DF6
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ECBC34114;
        Sun, 26 Jun 2022 20:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656274952;
        bh=oFDFJYPBvuhsw+mTtP9y3Qd8qzGpDx93zU5HCmq/M9s=;
        h=Date:To:From:Subject:From;
        b=EVWXV99teWAMsoKs+3Xtjl16BxkPkYH04Q7Wh4uWbhlqRfqXALCCvh+E5wsOhRVk5
         9RLbk9DTeohifq+7hinD97ZZ77YQFSvk972wj1Jm3cM5AZfZn8+RBImG8OkUV5Ydna
         2LL1jCpqwUtsLxxKqdFjC1KqEGRoUSnjwh/xKNOM=
Date:   Sun, 26 Jun 2022 13:22:31 -0700
To:     mm-commits@vger.kernel.org, chenxuebing@jari.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparsemem-drop-unexpected-word-a-in-comments.patch added to mm-unstable branch
Message-Id: <20220626202232.27ECBC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sparsemem: drop unexpected word 'a' in comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparsemem-drop-unexpected-word-a-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparsemem-drop-unexpected-word-a-in-comments.patch

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
From: "XueBing Chen" <chenxuebing@jari.cn>
Subject: mm: sparsemem: drop unexpected word 'a' in comments
Date: Sat, 25 Jun 2022 16:51:35 +0800 (GMT+08:00)

there is an unexpected word 'a' in the comments that need to be dropped

Link: https://lkml.kernel.org/r/24fbdae3.c86.1819a0f31b9.Coremail.chenxuebing@jari.cn
Signed-off-by: XueBing Chen <chenxuebing@jari.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse-vmemmap.c~mm-sparsemem-drop-unexpected-word-a-in-comments
+++ a/mm/sparse-vmemmap.c
@@ -556,7 +556,7 @@ pte_t * __meminit vmemmap_pte_populate(p
 		} else {
 			/*
 			 * When a PTE/PMD entry is freed from the init_mm
-			 * there's a a free_pages() call to this page allocated
+			 * there's a free_pages() call to this page allocated
 			 * above. Thus this get_page() is paired with the
 			 * put_page_testzero() on the freeing path.
 			 * This can only called by certain ZONE_DEVICE path,
_

Patches currently in -mm which might be from chenxuebing@jari.cn are

mm-sparsemem-drop-unexpected-word-a-in-comments.patch

