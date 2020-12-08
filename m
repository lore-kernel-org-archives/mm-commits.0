Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A95C4361B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9961623A23
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgLHAr3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 19:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbgLHAr3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 19:47:29 -0500
Date:   Mon, 07 Dec 2020 16:46:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607388382;
        bh=nLkD9zgO/lixia7sk0Pv6rkBI6WVPgKOgl5ASw22p4c=;
        h=From:To:Subject:From;
        b=wAVcJ7HIBC1DMv8RRvBE92s0Bz2KcsLOEBdp3D39lUcITfoRWvOgP2coKRtU1BgEX
         rOSUHq6ICGyGmyTKfErpzfqsXaEtDRaIXwl89mnnCP02AJo5X0Hf3AZOk4cuWTsXHg
         4ioopKvnmRpRp7q0sZ3IbJHn+9eNaT5W3ZrhyLA4=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de
Subject:  [merged]
 mailmap-add-two-more-addresses-of-uwe-kleine-oenig.patch removed from -mm
 tree
Message-ID: <20201208004622.DWdvO17EJ%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     mailmap-add-two-more-addresses-of-uwe-kleine-oenig.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

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


