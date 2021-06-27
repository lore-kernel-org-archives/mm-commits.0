Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B6FC48BC2
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2412261C32
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhF0V4t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Jun 2021 17:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V4s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B97461004;
        Sun, 27 Jun 2021 21:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830863;
        bh=Eia84v/JKXTsHnm44h+bhbd1N05DZEWyN3RomVBJttI=;
        h=Date:From:To:Subject:From;
        b=zqgCvp84h0OyIjCJFhgB5N6H/bLmzpuWoJ4ya8c/dbKpegYsO+3UjoRmbbjvIjWZ+
         Q9eQ2gL39wc5I4f3/dk6j7x6kfwTK3w5+0OtnK4vORQciFasFobieB9qoS425CK6A6
         yR5b2LmKPeAi8/5BbnHmAZhl9XUeVL6Nk8cQ35t8=
Date:   Sun, 27 Jun 2021 14:54:23 -0700
From:   akpm@linux-foundation.org
To:     kabel@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged] maintainers-fix-my-identity-again.patch removed
 from -mm tree
Message-ID: <20210627215423.ux-tX0M0t%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     maintainers-fix-my-identity-again.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
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

Patches currently in -mm which might be from kabel@kernel.org are


