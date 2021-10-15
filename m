Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E505C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F5B1611CE
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243043AbhJOVCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 17:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243051AbhJOVCN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 17:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7173611C8;
        Fri, 15 Oct 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634331604;
        bh=gm09Y1mkRy4DBA885jx6c0nBSxN3Ti5hlMfokqEOtfU=;
        h=Date:From:To:Subject:From;
        b=OYuRQEgsNIqhs6R/+yNB0W6LEFHlrUhZl7HmqKztOaAvll9BIrTPSqxGGnQtOpZdA
         OPIOBTUfvgy6Z3NXCnMNR3lp6rMJBwKPOQYTndASyNs5PQ4CHQnxyAe8gVdm5Agf4a
         YQ7PIZrEByRy8eN5kWCszb35V2irfEWVSLUdScqg=
Date:   Fri, 15 Oct 2021 14:00:04 -0700
From:   akpm@linux-foundation.org
To:     andrew.shadura@collabora.co.uk, mm-commits@vger.kernel.org
Subject:  + mailmap-add-andrej-shadura.patch added to -mm tree
Message-ID: <20211015210004.4WVgZvoGk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add Andrej Shadura
has been added to the -mm tree.  Its filename is
     mailmap-add-andrej-shadura.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-add-andrej-shadura.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-add-andrej-shadura.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrej Shadura <andrew.shadura@collabora.co.uk>
Subject: mailmap: add Andrej Shadura

Add a mapping for my old work email for BelDisplayTech to the personal
email, and make sure the Collabora email has the correct spelling of the
first name.

Link: https://lkml.kernel.org/r/20210917091016.30232-1-andrew.shadura@collabora.co.uk
Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-andrej-shadura
+++ a/.mailmap
@@ -33,6 +33,8 @@ Al Viro <viro@zenIV.linux.org.uk>
 Andi Kleen <ak@linux.intel.com> <ak@suse.de>
 Andi Shyti <andi@etezian.org> <andi.shyti@samsung.com>
 Andreas Herrmann <aherrman@de.ibm.com>
+Andrej Shadura <andrew.shadura@collabora.co.uk>
+Andrej Shadura <andrew@shadura.me> <andrew@beldisplaytech.com>
 Andrew Morton <akpm@linux-foundation.org>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <amurray@embedded-bits.co.uk>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
_

Patches currently in -mm which might be from andrew.shadura@collabora.co.uk are

mailmap-add-andrej-shadura.patch

