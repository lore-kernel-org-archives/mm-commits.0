Return-Path: <SRS0=Y9qB=DS=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD0BC43457
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 06:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55AC207FB
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 06:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602396993;
	bh=Cw4RibH/WopfNv6VEMK6G3V3q1tlsmSqiG63Ti+WSlo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MkVGuQCx//AMwC2IJKtObHmkNovMRppmJHmBWCT2weGj313IlZ6WOtXa6FRN2uEqM
	 lL1JZOLwhrGzU+erIuLXI/FnVQ6lh1pH7YnAaBV56dJWhjk1+eThP7h99DNBR/5ffI
	 hTP3a9eD0on59YaZQvmKLayX6P34IvgVnZFw2uIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgJKGQd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Oct 2020 02:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgJKGQd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Oct 2020 02:16:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FFD4207FB;
        Sun, 11 Oct 2020 06:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602396991;
        bh=Cw4RibH/WopfNv6VEMK6G3V3q1tlsmSqiG63Ti+WSlo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=19sPxDvu57eEDM9Ue+7umP3NjLJf2ybNsA4N+CrrrXvagiHS2n10ODj5N5sRtnVby
         4dUq1N2+jCrk/JpZ+QeEWsyOrj277byiheePRAQYaJzeUtw6rvPUSpk2fNUQDN0zu3
         WEq4CjvBhW+r7lPLSE70dKEcRYNkAXwZWNxhxv/o=
Date:   Sat, 10 Oct 2020 23:16:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, atenart@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 2/5] MAINTAINERS: Antoine Tenart's email address
Message-ID: <20201011061630.Fxx3Qo1b_%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>
Subject: MAINTAINERS: Antoine Tenart's email address

Use my kernel.org address instead of my bootlin.com one.

Link: https://lkml.kernel.org/r/20201005164533.16811-1-atenart@kernel.org
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    3 ++-
 MAINTAINERS |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/.mailmap~maintainers-update-my-email-address
+++ a/.mailmap
@@ -41,7 +41,8 @@ Andrew Murray <amurray@thegoodpenguin.co
 Andrew Vasquez <andrew.vasquez@qlogic.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <a.ryabinin@samsung.com>
 Andy Adamson <andros@citi.umich.edu>
-Antoine Tenart <antoine.tenart@free-electrons.com>
+Antoine Tenart <atenart@kernel.org> <antoine.tenart@bootlin.com>
+Antoine Tenart <atenart@kernel.org> <antoine.tenart@free-electrons.com>
 Antonio Ospite <ao2@ao2.it> <ao2@amarulasolutions.com>
 Archit Taneja <archit@ti.com>
 Ard Biesheuvel <ardb@kernel.org> <ard.biesheuvel@linaro.org>
--- a/MAINTAINERS~maintainers-update-my-email-address
+++ a/MAINTAINERS
@@ -1628,7 +1628,7 @@ N:	meson
 
 ARM/Annapurna Labs ALPINE ARCHITECTURE
 M:	Tsahee Zidenberg <tsahee@annapurnalabs.com>
-M:	Antoine Tenart <antoine.tenart@bootlin.com>
+M:	Antoine Tenart <atenart@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/boot/dts/alpine*
@@ -8678,7 +8678,7 @@ F:	drivers/input/input-mt.c
 K:	\b(ABS|SYN)_MT_
 
 INSIDE SECURE CRYPTO DRIVER
-M:	Antoine Tenart <antoine.tenart@bootlin.com>
+M:	Antoine Tenart <atenart@kernel.org>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/inside-secure/
_
