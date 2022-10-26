Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8017C38A02
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 02:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiJZCLf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 22:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJZCLe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 22:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC1D4D830
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 19:11:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 528F6B81FC3
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 02:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4ADC433D6;
        Wed, 26 Oct 2022 02:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666750291;
        bh=dgegSgZtixIEinvYYZAR4Y/t3b3AmqGa9XhJoyD26Q8=;
        h=Date:To:From:Subject:From;
        b=pt/wkexypcFKm/9wSe29yztnrNxgKi5fUzLLu8OU87/fKxG28dQaNSLiSGIBmsYTL
         MmE08EpGDx8EC6Liu5X6xjL0IgCkW1ue0PNX9efKGT3MFPwEXZE81FdLsGjJpsHKbY
         kaQZkK82b6i/InFEUCwsS7Yp6pdLBghFzEDHbF1I=
Date:   Tue, 25 Oct 2022 19:11:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, joe@perches.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-update-copyright-dates-for-test-code.patch added to mm-unstable branch
Message-Id: <20221026021130.DC4ADC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: update copyright dates for test code
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-update-copyright-dates-for-test-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-update-copyright-dates-for-test-code.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: update copyright dates for test code
Date: Tue, 25 Oct 2022 17:37:23 +0000

Add the span to the year of the development.

Link: https://lkml.kernel.org/r/20221025173709.2718725-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/radix-tree/maple.c~maple_tree-update-copyright-dates-for-test-code
+++ a/tools/testing/radix-tree/maple.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * maple_tree.c: Userspace shim for maple tree test-suite
- * Copyright (c) 2018 Liam R. Howlett <Liam.Howlett@Oracle.com>
+ * maple_tree.c: Userspace testing for maple tree test-suite
+ * Copyright (c) 2018-2022 Oracle Corporation
+ * Author: Liam R. Howlett <Liam.Howlett@Oracle.com>
  */
 
 #define CONFIG_DEBUG_MAPLE_TREE
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch

