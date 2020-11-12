Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061C7C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 18:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73E6F2222F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 18:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9y46rsW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgKLSpu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 13:45:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgKLSpu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 13:45:50 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6EFC22227;
        Thu, 12 Nov 2020 18:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605206750;
        bh=oLwiLx6Dbcl1gztSkmJavpda8pRVWTc1J6Z3cEzRGHo=;
        h=Date:From:To:Subject:From;
        b=c9y46rsW7mYc4mIXUgtrWkCI+ZYpLSs83n7nIeVI0H5g56xhwZs55oNLsotIwlTOJ
         kqdGih8FRBBXbaEqrBYJfrvgkQHhJsAgH9OtZ4ZmJom8IOfEh8XscPjeEcdXWSA7V4
         S2M6iA5Wsyu62DPMYVcavNipwQ7IXd4LNk5kIm/Y=
Date:   Thu, 12 Nov 2020 10:45:49 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, wangqing@vivo.com
Subject:  [merged]
 tool-selftests-fix-spelling-typo-of-writting.patch removed from -mm tree
Message-ID: <20201112184549.wVIOw_vVp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/userfaultfd.c: fix spelling typo of 'writting'
has been removed from the -mm tree.  Its filename was
     tool-selftests-fix-spelling-typo-of-writting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: tools/testing/selftests/vm/userfaultfd.c: fix spelling typo of 'writting'

writting -> writing

Link: https://lkml.kernel.org/r/1604740776-27082-1-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~tool-selftests-fix-spelling-typo-of-writting
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -894,7 +894,7 @@ static int faulting_process(int signal_t
 				count_verify[nr]);
 	        }
 		/*
-		 * Trigger write protection if there is by writting
+		 * Trigger write protection if there is by writing
 		 * the same value back.
 		 */
 		*area_count(area_dst, nr) = count;
@@ -922,7 +922,7 @@ static int faulting_process(int signal_t
 				count_verify[nr]); exit(1);
 		}
 		/*
-		 * Trigger write protection if there is by writting
+		 * Trigger write protection if there is by writing
 		 * the same value back.
 		 */
 		*area_count(area_dst, nr) = count;
_

Patches currently in -mm which might be from wangqing@vivo.com are


