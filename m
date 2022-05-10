Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4C8C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbiEJEWU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbiEJEUj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B355D2DAA6
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70AF8B81B11
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167E2C385C5;
        Tue, 10 May 2022 04:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156145;
        bh=B06fBH2x7KJd2kk0UHDsqqCx09yaDDAJgD5F2BE2EYI=;
        h=Date:To:From:Subject:From;
        b=QoM1AlYSwJMTv8ikSKFBVD7GvUqwd/+q0b2VtOHgUOJwCg55XuQbY+4fGVskJduGk
         SQteo7uhR/uPwC/HyU+bLnLJ4BB93fX1+CeFF26o7/UVTpYH5NZW/qrxEXCzpiVtUp
         2GqWlslIalLDHPvKM86JD05aoMPLKKUXIRE6qsL0=
Date:   Mon, 09 May 2022 21:15:44 -0700
To:     mm-commits@vger.kernel.org, ahuang12@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-fix-typos-in-comments.patch removed from -mm tree
Message-Id: <20220510041545.167E2C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: Fix typos in comments
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-typos-in-comments.patch

This patch was dropped because it was merged into mm-stable

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
@@ -298,7 +298,7 @@ int anon_vma_clone(struct vm_area_struct
 		 * Reuse existing anon_vma if its degree lower than two,
 		 * that means it has no vma and only one anon_vma child.
 		 *
-		 * Do not chose parent anon_vma, otherwise first child
+		 * Do not choose parent anon_vma, otherwise first child
 		 * will always reuse it. Root anon_vma is never reused:
 		 * it has self-parent reference and at least one child.
 		 */
@@ -2249,7 +2249,7 @@ static bool folio_make_device_exclusive(
 
 /**
  * make_device_exclusive_range() - Mark a range for exclusive use by a device
- * @mm: mm_struct of assoicated target process
+ * @mm: mm_struct of associated target process
  * @start: start of the region to mark for exclusive device access
  * @end: end address of region
  * @pages: returns the pages which were successfully marked for exclusive access
_

Patches currently in -mm which might be from ahuang12@lenovo.com are


