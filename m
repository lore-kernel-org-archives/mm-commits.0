Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6B1C48BC2
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 00:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE2EE61358
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 00:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFXBAW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 21:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhFXBAW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 21:00:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E769F6135C;
        Thu, 24 Jun 2021 00:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624496283;
        bh=7tCtz3x7X0fv1ey6pAVYzWBdeTgIszGPm6JxyW7CXEo=;
        h=Date:From:To:Subject:From;
        b=r/+lWwOWcgUxlCjxmVbiE64t6Nvb9VjKvtaTXb/I+Q3eICLSAb4M2q+/Q42OsHRFU
         O5pFO63+UVVdrsBNDeF/R3oYAgK1FIct4yCKmpTqqNxVd0/Sh6SR4aWrp/M+QDY+s2
         EGpqdJcEeGqSlY0B8KHQQXoPhKgngQ/pF4k/RNmc=
Date:   Wed, 23 Jun 2021 17:58:02 -0700
From:   akpm@linux-foundation.org
To:     kabel@kernel.org, mm-commits@vger.kernel.org
Subject:  + maintainers-fix-my-identity-again.patch added to -mm
 tree
Message-ID: <20210624005802.BWz-_okwo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix Marek's identity again
has been added to the -mm tree.  Its filename is
     maintainers-fix-my-identity-again.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-fix-my-identity-a=
gain.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-fix-my-identity-a=
gain.patch

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
=46rom: Marek Beh=C3=BAn <kabel@kernel.org>
Subject: MAINTAINERS: fix Marek's identity again

Fix my name to use diacritics, since MAINTAINERS supports it.

Fix my e-mail address in MAINTAINERS' marvell10g PHY driver description,
I accidentaly put my other e-mail address here.

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

Patches currently in -mm which might be from kabel@kernel.org are

maintainers-fix-my-identity-again.patch
mailmap-add-my-other-e-mail-address-and-identity-without-diacritics.patch

