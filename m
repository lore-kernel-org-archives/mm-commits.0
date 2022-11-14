Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6CFC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 14 Nov 2022 22:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbiKNW4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 17:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237783AbiKNWz5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 17:55:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08741B1C9
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 14:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 571216148F
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 22:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D7FC433C1;
        Mon, 14 Nov 2022 22:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668466554;
        bh=Bo1wsHVBVL/1y7dyEjPxBvq47UT8WS9cvf2Arr34s4I=;
        h=Date:To:From:Subject:From;
        b=mxXGrpWjbkrt+JlMfDdeRyV5waPnwQ30gNJfJGY8uplCpdytk58ke3P3KZovSRAXK
         oYG+SkGecypzjYmHNNPNg6ZswAVCOhrNPD0CnHWow+Uqzpq4xlI+WirKLCFF/CJq1u
         g0COy8D49OcspluLjZ0sxR75R7TS16dYqskWhS8o=
Date:   Mon, 14 Nov 2022 14:55:53 -0800
To:     mm-commits@vger.kernel.org, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleakc-fix-a-comment.patch added to mm-unstable branch
Message-Id: <20221114225554.A4D7FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak.c: fix a comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleakc-fix-a-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleakc-fix-a-comment.patch

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
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: mm/kmemleak.c: fix a comment
Date: Tue, 15 Nov 2022 01:14:26 +0800

I noticed a typo in a code comment and I fixed it.

Link: https://lkml.kernel.org/r/20221114171426.91745-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleakc-fix-a-comment
+++ a/mm/kmemleak.c
@@ -1470,7 +1470,7 @@ static void scan_gray_list(void)
 }
 
 /*
- * Conditionally call resched() in a object iteration loop while making sure
+ * Conditionally call resched() in an object iteration loop while making sure
  * that the given object won't go away without RCU read lock by performing a
  * get_object() if !pinned.
  *
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are

mm-kmemleakc-fix-a-comment.patch

