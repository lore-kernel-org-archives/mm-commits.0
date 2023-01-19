Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6E1C678D6
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjASBTM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjASBRl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:17:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F52069200
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C404BB81FBC
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653DFC433EF;
        Thu, 19 Jan 2023 01:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090930;
        bh=oZ6BDYlK6z65BPFBof36/5iIE655gfLafjo3a28nTic=;
        h=Date:To:From:Subject:From;
        b=KUu/DqRUpPxMS5fquYeSiFL0m2Kl98itg4ZOJe5G82hn30Q/PgYrjLo4bFbZVU0v6
         iXwfotvMtilb8Dv5wlR37YPhd0KKXoDNWFbwS8KyPUYsNeTLYr2n1nJz+PWa2K126q
         2aAH3gb0bQPyRgUS/wD/blAcqpIYFcs7A6BIvPC0=
Date:   Wed, 18 Jan 2023 17:15:29 -0800
To:     mm-commits@vger.kernel.org, xu.xin16@zte.com.cn, david@redhat.com,
        xu.panda@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-ksm_functional_tests-fix-a-typo-in-comment.patch removed from -mm tree
Message-Id: <20230119011530.653DFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: ksm_functional_tests: fix a typo in comment
has been removed from the -mm tree.  Its filename was
     selftests-vm-ksm_functional_tests-fix-a-typo-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xu Panda <xu.panda@zte.com.cn>
Subject: selftests/vm: ksm_functional_tests: fix a typo in comment
Date: Fri, 23 Dec 2022 10:50:24 +0800 (CST)

Fix a typo of "comaring" which should be "comparing".

Link: https://lkml.kernel.org/r/202212231050245952617@zte.com.cn
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_functional_tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/ksm_functional_tests.c~selftests-vm-ksm_functional_tests-fix-a-typo-in-comment
+++ a/tools/testing/selftests/vm/ksm_functional_tests.c
@@ -37,7 +37,7 @@ static bool range_maps_duplicates(char *
 	/*
 	 * There is no easy way to check if there are KSM pages mapped into
 	 * this range. We only check that the range does not map the same PFN
-	 * twice by comaring each pair of mapped pages.
+	 * twice by comparing each pair of mapped pages.
 	 */
 	for (offs_a = 0; offs_a < size; offs_a += pagesize) {
 		pfn_a = pagemap_get_pfn(pagemap_fd, addr + offs_a);
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are


