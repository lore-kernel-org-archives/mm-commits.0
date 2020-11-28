Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BED5C3E8C5
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29F5221D46
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="12GCDV78"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbgK1C1h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Nov 2020 21:27:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730624AbgK1C1J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 21:27:09 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B390920809;
        Sat, 28 Nov 2020 02:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606530421;
        bh=sRt+h5n5DWINTmwI3XX+YjziSh1N8SikOA6ZEQGNRw4=;
        h=Date:From:To:Subject:From;
        b=12GCDV788qloIvtn7nHXP3ecRelp9eN6yVMvLjqtNNu/Lrm+pPrByP2SoPBavICb+
         67mxS9LW70BYONEmBBCaW1Pk2Y5IuVNBStU35kUNqbiTpY80hCE7ObC/stC29D6Axu
         ISGkUYE70iSryRj/SrOgrtFDB2sxM/WSCr558tHo=
Date:   Fri, 27 Nov 2020 18:27:01 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de
Subject:  +
 mailmap-add-two-more-addresses-of-uwe-kleine-oenig.patch added to -mm tree
Message-ID: <20201128022701.VATEQy6B2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add two more addresses of Uwe Kleine-K=C3=B6nig
has been added to the -mm tree.  Its filename is
     mailmap-add-two-more-addresses-of-uwe-kleine-oenig.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-add-two-more-addresse=
s-of-uwe-kleine-oenig.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-add-two-more-addresse=
s-of-uwe-kleine-oenig.patch

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
=46rom: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Subject: mailmap: add two more addresses of Uwe Kleine-K=C3=B6nig

This fixes attribution for the commits (among others)

- d4097456cd1d ("video/framebuffer: move the probe func into
  .devinit.text in Blackfin LCD driver")

- 0312e024d6cd ("mfd: mc13xxx: Add support for mc34708")

Link: https://lkml.kernel.org/r/20201127213358.3440830-1-u.kleine-koenig@pe=
ngutronix.de
Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-two-more-addresses-of-uwe-kleine-oenig
+++ a/.mailmap
@@ -322,6 +322,8 @@ TripleX Chung <xxx.phy@gmail.com> <zhong
 Tsuneo Yoshioka <Tsuneo.Yoshioka@f-secure.com>
 Tycho Andersen <tycho@tycho.pizza> <tycho@tycho.ws>
 Uwe Kleine-K=C3=B6nig <ukleinek@informatik.uni-freiburg.de>
+Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
+Uwe Kleine-K=C3=B6nig <ukleinek@strlen.de>
 Uwe Kleine-K=C3=B6nig <ukl@pengutronix.de>
 Uwe Kleine-K=C3=B6nig <Uwe.Kleine-Koenig@digi.com>
 Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de=
 are

mailmap-add-two-more-addresses-of-uwe-kleine-oenig.patch

