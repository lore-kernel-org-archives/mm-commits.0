Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACE5C49EA6
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62910613BA
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhFYBmb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233030AbhFYBmb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE52C60232;
        Fri, 25 Jun 2021 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585211;
        bh=9c0U8fD5uVXlVgePQ/pnrxkFPK0hib3jZ7NU3RSlhoI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eafTifU63HJ7GrxHoeU2HPoK8X3F0gDs2WFilwtiZlEna06y2tu1oWy1eaPVVTwuk
         JzN5SPJm1CirwnZ23/zugLk63wuzsknEQBNx/wtIVGac0N9WgUqwXJRvs8Hp873rT3
         CzgTpAvMtxSQhw2luynNUb04OLIl65U7mKnbmasg=
Date:   Thu, 24 Jun 2021 18:40:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kabel@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 23/24] MAINTAINERS: fix Marek's identity again
Message-ID: <20210625014010.1yt5MgkIv%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Marek Beh=C3=BAn <kabel@kernel.org>
Subject: MAINTAINERS: fix Marek's identity again

Fix my name to use diacritics, since MAINTAINERS supports it.

Fix my e-mail address in MAINTAINERS' marvell10g PHY driver description,
I accidentally put my other e-mail address here.

Link: https://lkml.kernel.org/r/20210616113624.19351-1-kabel@kernel.org
Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-fix-my-identity-again
+++ a/MAINTAINERS
@@ -1816,7 +1816,7 @@ F:	drivers/pinctrl/pinctrl-gemini.c
 F:	drivers/rtc/rtc-ftrtc010.c
=20
 ARM/CZ.NIC TURRIS SUPPORT
-M:	Marek Behun <kabel@kernel.org>
+M:	Marek Beh=C3=BAn <kabel@kernel.org>
 S:	Maintained
 W:	https://www.turris.cz/
 F:	Documentation/ABI/testing/debugfs-moxtet
@@ -10946,7 +10946,7 @@ F:	include/linux/mv643xx.h
=20
 MARVELL MV88X3310 PHY DRIVER
 M:	Russell King <linux@armlinux.org.uk>
-M:	Marek Behun <marek.behun@nic.cz>
+M:	Marek Beh=C3=BAn <kabel@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/phy/marvell10g.c
_
