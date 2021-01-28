Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E88C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8E9264DD1
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhA1ANx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbhA1ANu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:13:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A47DA64DD1;
        Thu, 28 Jan 2021 00:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611792784;
        bh=A3jOe0Dn35lcFbKp/K6hPjQDYWhdtdLpt6bpi77IB6E=;
        h=Date:From:To:Subject:From;
        b=XiY9dE77PwCDhKbMyEFP0JboVWAo7KiGO7hCOeDqHuhpd/87MzlrFvYkFJL66Nqqw
         0ZKHb9/AYBX5dVQphbflXMbW8mXqw1/Nd1QD+BmJLM4XbV6P2qNi+FoHdHv8oCat8E
         yyRxi4sbPdzuDV6mi9A1kTnK6eSbXIX1DSpZvg9c=
Date:   Wed, 27 Jan 2021 16:13:04 -0800
From:   akpm@linux-foundation.org
To:     dingsenjie@yulong.com, mm-commits@vger.kernel.org
Subject:  + scripts-spellingtxt-add-allocted-and-exeeds-typo.patch
 added to -mm tree
Message-ID: <20210128001304.FAJpaeDvB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "allocted" and "exeeds" typo
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-allocted-and-exeeds-typo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-allocted-and-exeeds-typo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-allocted-and-exeeds-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: dingsenjie <dingsenjie@yulong.com>
Subject: scripts/spelling.txt: add "allocted" and "exeeds" typo

Increase "allocted" and "exeeds" spelling error check.

Link: https://lkml.kernel.org/r/20210127081919.1928-1-dingsenjie@163.com
Signed-off-by: dingsenjie <dingsenjie@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-allocted-and-exeeds-typo
+++ a/scripts/spelling.txt
@@ -103,6 +103,7 @@ alloated||allocated
 allocatote||allocate
 allocatrd||allocated
 allocte||allocate
+allocted||allocated
 allpication||application
 alocate||allocate
 alogirhtms||algorithms
@@ -574,6 +575,7 @@ excellant||excellent
 execeeded||exceeded
 execeeds||exceeds
 exeed||exceed
+exeeds||exceeds
 exeuction||execution
 existance||existence
 existant||existent
_

Patches currently in -mm which might be from dingsenjie@yulong.com are

scripts-spellingtxt-add-allocted-and-exeeds-typo.patch

