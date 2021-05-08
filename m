Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B6DC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 584C260E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhEHWz6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhEHWz6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8073061432;
        Sat,  8 May 2021 22:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514496;
        bh=fQqk3XdcH9OgU765n0IYFkyZdi9tnGRshGyZh35Tkgs=;
        h=Date:From:To:Subject:From;
        b=FSx6u4tUGRzPsGXgOixhu8qmjyYd6ucmZ63yiLJ5YrqymcCbHv+1rTXlm7qd+Sfy0
         KTQyOBKXBqYXNFbeCvOU0VUH17BpQfA4yJZLE550yLsHy+Cx0nBOJwqsj/Dw/l1Tum
         83/pVm78PsT5RB2fP9HykN9WGUSWwS+MqUe5CL/k=
Date:   Sat, 08 May 2021 15:54:56 -0700
From:   akpm@linux-foundation.org
To:     drew@beagleboard.org, gustavoars@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [merged] scripts-spellingtxt-add-overflw.patch removed
 from -mm tree
Message-ID: <20210508225456.X3QBZrrv7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "overflw"
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-overflw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Drew Fustini <drew@beagleboard.org>
Subject: scripts/spelling.txt: add "overflw"

Add typo "overflw" for "overflow".  This typo was found and fixed in
drivers/clocksource/timer-pistachio.c.

Link: https://lore.kernel.org/lkml/20210305090315.384547-1-drew@beagleboard.org/
Link: https://lkml.kernel.org/r/20210305095151.388182-1-drew@beagleboard.org
Signed-off-by: Drew Fustini <drew@beagleboard.org>
Suggested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-overflw
+++ a/scripts/spelling.txt
@@ -1028,6 +1028,7 @@ oustanding||outstanding
 overaall||overall
 overhread||overhead
 overlaping||overlapping
+overflw||overflow
 overlfow||overflow
 overide||override
 overrided||overridden
_

Patches currently in -mm which might be from drew@beagleboard.org are


