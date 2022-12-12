Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAC2C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiLLCSi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiLLCQ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46365DFFF
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:15:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E49B7B80B69
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22F7C433F0;
        Mon, 12 Dec 2022 02:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811308;
        bh=6JLAJut2wXgLS7FqU+3hPE5IPdf9+djXF79WsTN+3xQ=;
        h=Date:To:From:Subject:From;
        b=hlG2kMFspDWR+GdLxNx1bu1hz3B7kzjG9n+D67JXenraii247ftlAuD9beSmUznYj
         S0EaUD49avgUMBYNHDXnG13htOty4A8RwTPV3pS0k+t0jmfG8R47VdkFRGGTMlqukq
         Yj2Zm1NLUp8zndP6yWTO8cK7S1r21U+H3MR0l2pU=
Date:   Sun, 11 Dec 2022 18:15:07 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        yongw.kernel@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-typo-in-struct-pglist_data-code-comment.patch removed from -mm tree
Message-Id: <20221212021508.A22F7C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix typo in struct pglist_data code comment
has been removed from the -mm tree.  Its filename was
     mm-fix-typo-in-struct-pglist_data-code-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yong <yongw.kernel@gmail.com>
Subject: mm: fix typo in struct pglist_data code comment
Date: Wed, 7 Dec 2022 07:40:11 +0000

change "stat" to "start".

Link: https://lkml.kernel.org/r/20221207074011.GA151242@cloud
Fixes: c959924b0dc5 ("memory tiering: adjust hot threshold automatically")
Signed-off-by: Wang Yong <yongw.kernel@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-fix-typo-in-struct-pglist_data-code-comment
+++ a/include/linux/mmzone.h
@@ -1200,7 +1200,7 @@ typedef struct pglist_data {
 	/* start time in ms of current promote threshold adjustment period */
 	unsigned int nbp_th_start;
 	/*
-	 * number of promote candidate pages at stat time of current promote
+	 * number of promote candidate pages at start time of current promote
 	 * threshold adjustment period
 	 */
 	unsigned long nbp_th_nr_cand;
_

Patches currently in -mm which might be from yongw.kernel@gmail.com are


