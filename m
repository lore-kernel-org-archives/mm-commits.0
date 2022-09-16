Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87586C6FA86
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 20:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiIPUBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 16:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiIPUBh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 16:01:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2C1B6D68
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 13:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E7CFCE1E2F
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 20:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85481C433C1;
        Fri, 16 Sep 2022 20:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663358492;
        bh=fl1eeWSJFmIag/vXmKxv4F2W+wBGhyTu5FBtw7VpI1s=;
        h=Date:To:From:Subject:From;
        b=Hf1772wpr19vdVcm0BGvaBVmST8FeZmd6epscD95xqHH9nswt0sjsEN6v8ysDdG+3
         SVxMxkYc+rTOOekuYhilipr8kWbWFGX9UVOHnyV87gNqjdHq7OCJ71AiQL1Uj+V2Qo
         ST06aBa8NzS1UsLjODem4Yu8V8zgxYMj56No2EMM=
Date:   Fri, 16 Sep 2022 13:01:31 -0700
To:     mm-commits@vger.kernel.org, shiyn.lin@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-fix-typos.patch added to mm-unstable branch
Message-Id: <20220916200132.85481C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: fix typos
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-fix-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-fix-typos.patch

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
From: Chih-En Lin <shiyn.lin@gmail.com>
Subject: mm/page_table_check: fix typos
Date: Fri, 16 Sep 2022 17:04:34 +0800

Link: https://lkml.kernel.org/r/20220916090434.701194-1-shiyn.lin@gmail.com
Signed-off-by: Chih-En Lin <shiyn.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-fix-typos
+++ a/mm/page_table_check.c
@@ -53,7 +53,7 @@ static struct page_table_check *get_page
 }
 
 /*
- * An enty is removed from the page table, decrement the counters for that page
+ * An entry is removed from the page table, decrement the counters for that page
  * verify that it is of correct type and counters do not become negative.
  */
 static void page_table_check_clear(struct mm_struct *mm, unsigned long addr,
@@ -87,7 +87,7 @@ static void page_table_check_clear(struc
 }
 
 /*
- * A new enty is added to the page table, increment the counters for that page
+ * A new entry is added to the page table, increment the counters for that page
  * verify that it is of correct type and is not being mapped with a different
  * type to a different process.
  */
_

Patches currently in -mm which might be from shiyn.lin@gmail.com are

mm-page_table_check-fix-typos.patch

