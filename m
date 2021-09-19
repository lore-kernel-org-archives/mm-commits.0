Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AC3C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2F5960F93
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhISXYP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISXYP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:24:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2576F60F36;
        Sun, 19 Sep 2021 23:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632093769;
        bh=eh1v6Oy93iQ1Y8z1Ut9iQF04G8jhUmgpl8S5uy3BLj4=;
        h=Date:From:To:Subject:From;
        b=mjVgiBYCHxtvH69aW/TxLjK8v8++7xprk7/yyxjCuDWqmTmJZkCOxxDr1o95dhudP
         6aSQqx4Lmx+UDv9go1Aqw0wHp1l+T0DeAvxIh/U9ueZcx/+jrCYSZboC6mzmQfS7Q5
         NP9Tr5QZirgFIJw57k++bntD+NHikMBwn5AXmxsA=
Date:   Sun, 19 Sep 2021 16:22:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjpark@amazon.de, corbet@lwn.net,
        sj@kernel.org
Subject:  + maintainers-update-seongjaes-email-address.patch added to
 -mm tree
Message-ID: <20210919232248.YHJcj%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update SeongJae's email address
has been added to the -mm tree.  Its filename is
     maintainers-update-seongjaes-email-address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-seongjaes-email-address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-seongjaes-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS: update SeongJae's email address

This commit updates SeongJae's email address in MAINTAINERS file to his
preferred one.

Link: https://lkml.kernel.org/r/20210917123958.3819-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-seongjaes-email-address
+++ a/MAINTAINERS
@@ -5155,7 +5155,7 @@ F:	net/ax25/ax25_timer.c
 F:	net/ax25/sysctl_net_ax25.c
 
 DATA ACCESS MONITOR
-M:	SeongJae Park <sjpark@amazon.de>
+M:	SeongJae Park <sj@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/damon/
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch

