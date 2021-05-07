Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860A1C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67CAF613C2
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhEGBHS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhEGBHS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B0F4613C9;
        Fri,  7 May 2021 01:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349579;
        bh=nfkxglcI++Q2axrtM51bZmmcpKjElgU58AIe8SUzcOI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xIeeTQHsxBh/fCOBzop+kQqT+4tYTJITjr3bNOUJpvhcjrUocvYr7t/FBrGU7IHmv
         VrbNxJd4I6CRh1q9gDyGTUngt8ydLN0JE0T+7PEL23A4zXlQQtRzg51H9xzI+Xp0j3
         z2sOtsvvB9M0RKkZ49UJtNtyLg1Yl0imsPJSugW0=
Date:   Thu, 06 May 2021 18:06:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, drew@beagleboard.org,
        gustavoars@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 80/91] scripts/spelling.txt: add "overflw"
Message-ID: <20210507010618.srI6puT_8%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
