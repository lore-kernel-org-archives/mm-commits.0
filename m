Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA17C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A7DC613D6
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhEGBHM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231499AbhEGBHM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 640AA613C2;
        Fri,  7 May 2021 01:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349573;
        bh=A4knmZjIgDCWQIhzVuFBaW1EcM3HRuQqokTZ/jvfFfg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MotTHRSMI4eSbscbDP2bVTZ/qIr/72EQXlEFNAp6L7PXGoS153b77RuZtEtOzF3Ap
         tCsEhliOciDE8NbSlXLMWAGshxpUQT3fx558z5EAy2GflNew87kR6WZOCDnNRKSvPl
         rdt5nwUviY40IyLRBF4715nS2eysGMX34CW8lY1c=
Date:   Thu, 06 May 2021 18:06:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, drew@beagleboard.org,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 78/91] scripts/spelling.txt: add "overlfow"
Message-ID: <20210507010612.q1De4t7xN%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Drew Fustini <drew@beagleboard.org>
Subject: scripts/spelling.txt: add "overlfow"

Add typo "overlfow" for "overflow". This typo was found and fixed in
net/sctp/tsnmap.c.

Link: https://lore.kernel.org/netdev/20210304055548.56829-1-drew@beagleboard.org/
Link: https://lkml.kernel.org/r/20210304072657.64577-1-drew@beagleboard.org
Signed-off-by: Drew Fustini <drew@beagleboard.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-overlfow
+++ a/scripts/spelling.txt
@@ -1027,6 +1027,7 @@ oustanding||outstanding
 overaall||overall
 overhread||overhead
 overlaping||overlapping
+overlfow||overflow
 overide||override
 overrided||overridden
 overriden||overridden
_
