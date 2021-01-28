Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C38C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4549D64DCE
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhA1AOw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:14:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbhA1AOs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:14:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A010164DCC;
        Thu, 28 Jan 2021 00:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611792845;
        bh=sDSbTYDxajo2FzZWQKOHstBkk45HvzUN9imU5od1szk=;
        h=Date:From:To:Subject:From;
        b=k4NsA0oqSXV9aP9UvQ8jOGyQMc+hW1Cp9BPVeVUvSOUQ6Pa+N3W9MA1z7ObMu+b2B
         M8dEyvn9TC2K2iyOU9BdzAvgmflm9/SOaG+SOu0R1dqy7o7DHPKgDkeeDlPMKDhLcz
         qUzttKcBIVlgKDRdxYavp/C8SogQ5yNT4eWl53x4=
Date:   Wed, 27 Jan 2021 16:14:05 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zuoqilin@yulong.com
Subject:  +
 scripts-spellingtxt-increase-error-prone-spell-checking-2.patch added to
 -mm tree
Message-ID: <20210128001405.O1jd1qP6t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: increase error-prone spell checking
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-increase-error-prone-spell-checking-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-increase-error-prone-spell-checking-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-increase-error-prone-spell-checking-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zuoqilin <zuoqilin@yulong.com>
Subject: scripts/spelling.txt: increase error-prone spell checking

Increase exeeds spelling error check.

Link: https://lkml.kernel.org/r/20210127060049.915-1-zuoqilin1@163.com
Signed-off-by: zuoqilin <zuoqilin@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-increase-error-prone-spell-checking-2
+++ a/scripts/spelling.txt
@@ -566,6 +566,7 @@ estbalishment||establishment
 etsablishment||establishment
 etsbalishment||establishment
 evalution||evaluation
+exeeds||exceeds
 excecutable||executable
 exceded||exceeded
 exceds||exceeds
_

Patches currently in -mm which might be from zuoqilin@yulong.com are

scripts-spellingtxt-increase-error-prone-spell-checking-2.patch

