Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2486FC388F9
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D51B42151B
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 01:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604797260;
	bh=0AzV/hF2BkSobiDFKPS0BKdBB+HC8xDkWTiuYBawyYA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sJbAs1xRj8q+qw7RlUt/jPApgeSboZi58PcM2aUZWsj3NlH8mrznPHpLi9T/TmweQ
	 9QCH4/P6JTXsEn+GUXnJCxKuJa/+IM1EhlIcmWdXmLhXPB99OE8XoVwcoO92Zeojwa
	 TC6FcwzpIqpteqswv1gHxQT12WXhbjsaM4BHBZkA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgKHBBA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 20:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKHBBA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 20:01:00 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E2120885;
        Sun,  8 Nov 2020 01:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604797259;
        bh=0AzV/hF2BkSobiDFKPS0BKdBB+HC8xDkWTiuYBawyYA=;
        h=Date:From:To:Subject:From;
        b=N6ZxLSkG99TVNaaidZDTtrWdNdGGv1MXjhD4kwvxLwbTJdvkCNyJp3Y0ROsSkmZ84
         ytEYmiZZW3QSxXCtYVQfbi29DOqhNlS3rPfjgTy2jaY1DqtgQyfTandqWQYbQmF7Tq
         568UVUtc+GOMgm6o+uwj0+7MKet8tkQ5qbe92vUw=
Date:   Sat, 07 Nov 2020 17:00:59 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, wangqing@vivo.com
Subject:  + tool-selftests-fix-spelling-typo-of-writting.patch
 added to -mm tree
Message-ID: <20201108010059.XPCwrhesP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/userfaultfd.c: fix spelling typo of 'writting'
has been added to the -mm tree.  Its filename is
     tool-selftests-fix-spelling-typo-of-writting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tool-selftests-fix-spelling-typo-of-writting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tool-selftests-fix-spelling-typo-of-writting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tool-selftests-fix-spelling-typo-of-writting.patch

