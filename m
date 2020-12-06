Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BD5C433FE
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F332622D0B
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 06:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgLFGQC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Dec 2020 01:16:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgLFGQA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 6 Dec 2020 01:16:00 -0500
Date:   Sat, 05 Dec 2020 22:14:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607235299;
        bh=VCYQU5172HyRceXQnWz4lrS1BeIbfVsVDviDRKyMdEw=;
        h=From:To:Subject:In-Reply-To:From;
        b=VI284WkQPo8yfwtIIDvu23lEFySziPoXAdh3NRuIDytD58m9TNTRMvWLX64RLAZhA
         txtWHZpUghCG9IKgA+oRF2u+mPV5+/MoSGoyJOgMuLcLSiLfJt7Km3Oia+2DHRFvDA
         PP8jP0sUb8RZjF1Sj/3RlExBnVEUYrlvP4ikgGcI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        u.kleine-koenig@pengutronix.de
Subject:  [patch 07/12] mailmap: add two more addresses of Uwe
 =?utf-8?Q?Kleine-K=C3=B6nig?=
Message-ID: <20201206061458.WikZEuFQW%akpm@linux-foundation.org>
In-Reply-To: <20201205221412.67f14b9b3a5ef531c76dd452@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
