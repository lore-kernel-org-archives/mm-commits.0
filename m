Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71E0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 23:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353253AbiD1XZB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 19:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiD1XZA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 19:25:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C86BC870
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 16:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9C04CE2F77
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 23:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148B6C385AD;
        Thu, 28 Apr 2022 23:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651188101;
        bh=1sNROCMgP7St0ohWU6vLYklCVx+HcNgMBIVRPwIXpvw=;
        h=Date:To:From:Subject:From;
        b=A8be0sDtc6X6GPoyh9a27n3r3l4JgOPqF0X/gfZQCs2mq+Lsq2aRPTT+m/i73i+O2
         lV1XfBdKiSgDrbsFL1VGKymuaxgmXN7/31jTC1A2p5gbt+vdBKvaRBc52cExlb5txF
         fzwjPGQpKJsO6DEjJhUXVaPO/yxDxhNF3MvVGWYE=
Date:   Thu, 28 Apr 2022 16:21:40 -0700
To:     mm-commits@vger.kernel.org, ahuang12@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-typos-in-comments.patch added to -mm tree
Message-Id: <20220428232141.148B6C385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: Fix typos in comments
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-typos-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-typos-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-typos-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Adrian Huang <ahuang12@lenovo.com>
Subject: mm/rmap: Fix typos in comments

Fix spelling/grammar mistakes in comments.

Link: https://lkml.kernel.org/r/20220428061522.666-1-adrianhuang0701@gmail.com
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-typos-in-comments
+++ a/mm/rmap.c
@@ -299,7 +299,7 @@ int anon_vma_clone(struct vm_area_struct
 		 * Reuse existing anon_vma if its degree lower than two,
 		 * that means it has no vma and only one anon_vma child.
 		 *
-		 * Do not chose parent anon_vma, otherwise first child
+		 * Do not choose parent anon_vma, otherwise first child
 		 * will always reuse it. Root anon_vma is never reused:
 		 * it has self-parent reference and at least one child.
 		 */
@@ -2257,7 +2257,7 @@ static bool folio_make_device_exclusive(
 
 /**
  * make_device_exclusive_range() - Mark a range for exclusive use by a device
- * @mm: mm_struct of assoicated target process
+ * @mm: mm_struct of associated target process
  * @start: start of the region to mark for exclusive device access
  * @end: end address of region
  * @pages: returns the pages which were successfully marked for exclusive access
_

Patches currently in -mm which might be from ahuang12@lenovo.com are

mm-rmap-fix-typos-in-comments.patch

