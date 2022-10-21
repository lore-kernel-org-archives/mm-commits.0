Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C45DC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 01:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiJUBiF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 21:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJUBiE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 21:38:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259F210DE7E
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 18:38:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF204B82A05
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 01:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E276C433C1;
        Fri, 21 Oct 2022 01:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666316281;
        bh=ooS8Xrhl0z90R9F4RUxzR8inrFhdWiPtyH/1KMn1fBE=;
        h=Date:To:From:Subject:From;
        b=rIX9KjCESdeC4y+NoWTivwv2jSZvSQMoM9uWhBUCgEUcEO96a1oycpPQQMmu9iF6L
         QZy3fMctQpOwuE6XztUnzQamG2rRh9tzvWVutN2PZoM7KNeUPfQuMVOsNl4MqC7UBc
         XLXK7+3vuuWKWBFnXoQ2fyNgxIhFW9xENPdThlIU=
Date:   Thu, 20 Oct 2022 18:38:00 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix-2.patch added to mm-unstable branch
Message-Id: <20221021013801.7E276C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup_test: remove unneeded semicolon
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix-2.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm: gup_test: remove unneeded semicolon
Date: Thu, 20 Oct 2022 10:40:35 +0800

./mm/gup_test.c:281:2-3: Unneeded semicolon

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2455
Link: https://lkml.kernel.org/r/20221020024035.113619-1-yang.lee@linux.alibaba.com
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup_test.c~mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix-2
+++ a/mm/gup_test.c
@@ -278,7 +278,7 @@ static inline int pin_longterm_test_star
 		}
 		pin_longterm_test_nr_pages += cur_pages;
 		pages += cur_pages;
-	};
+	}
 
 	if (!fast)
 		mmap_read_unlock(current->mm);
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix-2.patch

