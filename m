Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84C9C4708F
	for <mm-commits@archiver.kernel.org>; Wed,  2 Jun 2021 22:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC95A61401
	for <mm-commits@archiver.kernel.org>; Wed,  2 Jun 2021 22:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhFBW0d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFBW0d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Jun 2021 18:26:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE793613AC;
        Wed,  2 Jun 2021 22:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622672676;
        bh=QtcBx5XQUkjRIc3DCpTHBmqOLL/EOmaoJc2ZyfKFgTk=;
        h=Date:From:To:Subject:From;
        b=hm2imZmB/i9M1s9ZsonL66Jrx5DgeJH+M56rk7ecJJlVf1GkqBVxV78kWFElGFGeF
         0E+BH6jQQp2OM848J0BjMCBsX2sRX10FLTLkevzyf49rqc1iS/291leym8upY7MILN
         uenJcjT+tJdroGPmlQ2iuRQSPFlG6q8IctNUIQ6A=
Date:   Wed, 02 Jun 2021 15:24:35 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, michel@lespinasse.org, mm-commits@vger.kernel.org
Subject:  + mailmap-use-private-address-for-michel-lespinasse.patch
 added to -mm tree
Message-ID: <20210602222435.sUZAJH-On%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: use private address for Michel Lespinasse
has been added to the -mm tree.  Its filename is
     mailmap-use-private-address-for-michel-lespinasse.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-use-private-address-f=
or-michel-lespinasse.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-use-private-address-f=
or-michel-lespinasse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Michel Lespinasse <michel@lespinasse.org>
Subject: mailmap: use private address for Michel Lespinasse

Link: https://lkml.kernel.org/r/20210602221225.49446-1-michel@lespinasse.org
Signed-off-by: Michel Lespinasse <michel@lespinasse.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-use-private-address-for-michel-lespinasse
+++ a/.mailmap
@@ -243,6 +243,9 @@ Maxime Ripard <mripard@kernel.org> <maxi
 Mayuresh Janorkar <mayur@ti.com>
 Michael Buesch <m@bues.ch>
 Michel D=C3=A4nzer <michel@tungstengraphics.com>
+Michel Lespinasse <michel@lespinasse.org>
+Michel Lespinasse <michel@lespinasse.org> <walken@google.com>
+Michel Lespinasse <michel@lespinasse.org> <walken@zoy.org>
 Miguel Ojeda <ojeda@kernel.org> <miguel.ojeda.sandonis@gmail.com>
 Mike Rapoport <rppt@kernel.org> <mike@compulab.co.il>
 Mike Rapoport <rppt@kernel.org> <mike.rapoport@gmail.com>
_

Patches currently in -mm which might be from michel@lespinasse.org are

mailmap-use-private-address-for-michel-lespinasse.patch

