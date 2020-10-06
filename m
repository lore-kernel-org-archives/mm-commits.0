Return-Path: <SRS0=SqaX=DN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9B9C41604
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 04:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5E4E20782
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 04:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601959693;
	bh=V0jZ5UZ2nbxHG8SjBQJqGXjF58fVTZwTZz87L6il5AQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GJtFEeykLzn8WSfxjEed7bVrjX65cNEkKTOIE9NGoi7RjQNqIW6FoVwbm5eCT4USo
	 A5087araMwOFg6M6C3IbFqhHWOhiBbrt6jefsFTvXy5FkaTyob519tXZ/gp+iUmnSd
	 pHLXkSo0pLOI6tCpuNultaXKwul/l9RlJl3yIrpc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgJFEsN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgJFEsN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Oct 2020 00:48:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB7E120782;
        Tue,  6 Oct 2020 04:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601959692;
        bh=V0jZ5UZ2nbxHG8SjBQJqGXjF58fVTZwTZz87L6il5AQ=;
        h=Date:From:To:Subject:From;
        b=bhDTtR3AAi1jkOL/slj3/oULO1PaXVH2hQnOx09DuPi8fP9vs+VRConBcgNKKEyJY
         Ef4cY6dU07SOQmuAWwEYqxH/PiFSmx13bLYhvZR/mM1cyx7ThaYwQc/K4fXja9tOha
         K9IH+7icpCtNwr1NBT41MatMzSU2VOa120KxgS8w=
Date:   Mon, 05 Oct 2020 21:48:12 -0700
From:   akpm@linux-foundation.org
To:     atenart@kernel.org, mm-commits@vger.kernel.org
Subject:  + maintainers-update-my-email-address.patch added to -mm
 tree
Message-ID: <20201006044812.vSSG5whdB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Antoine Tenart's email address
has been added to the -mm tree.  Its filename is
     maintainers-update-my-email-address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-my-email-address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-my-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1623,7 +1623,7 @@ N:	meson
 
 ARM/Annapurna Labs ALPINE ARCHITECTURE
 M:	Tsahee Zidenberg <tsahee@annapurnalabs.com>
-M:	Antoine Tenart <antoine.tenart@bootlin.com>
+M:	Antoine Tenart <atenart@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/boot/dts/alpine*
@@ -8673,7 +8673,7 @@ F:	drivers/input/input-mt.c
 K:	\b(ABS|SYN)_MT_
 
 INSIDE SECURE CRYPTO DRIVER
-M:	Antoine Tenart <antoine.tenart@bootlin.com>
+M:	Antoine Tenart <atenart@kernel.org>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/inside-secure/
_

Patches currently in -mm which might be from atenart@kernel.org are

maintainers-update-my-email-address.patch

