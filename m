Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B3BC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 20:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA24520BED
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 20:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602621692;
	bh=XHbel/KN06AgfmWIScS+GPFCsaDXTzhPZEuO0uLhbLg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FPyWvTqkJAVSDdwLVPUpY1dRY584cOfsxB3SUrBk0FS1qImvjb9S7u0oSusKCIqIG
	 9ch4Sd0T9fo+688hgOTqxPv/vYyA0ADalnGgYEwSsazKRpDcqXQuyt71PYCOYEx3OU
	 W01TdextxfvOGHsvFHQsxxKa4mWtplSROIgnEqJM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgJMUlc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 16:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJMUlc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 16:41:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DA89208D5;
        Tue, 13 Oct 2020 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602621691;
        bh=XHbel/KN06AgfmWIScS+GPFCsaDXTzhPZEuO0uLhbLg=;
        h=Date:From:To:Subject:From;
        b=kZ1I/d0JgVYbA6FW+qS4I9jwclfTgpxCbCtrHGD49YHIHW6w0fpLmwX5w58VodJOJ
         zrULmN/3HRNP4cLU1mnhQ72AHS+wnavzpCsbqKPjXpALey2b4eVnhxs4g3aXM9oGdO
         WLXKRMnEDsR0aOO6pyO1GLZWgEAfLDbw9NdWlhXU=
Date:   Tue, 13 Oct 2020 13:41:31 -0700
From:   akpm@linux-foundation.org
To:     atenart@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged] maintainers-update-my-email-address.patch
 removed from -mm tree
Message-ID: <20201013204131.idahpgtyA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Antoine Tenart's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-my-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from atenart@kernel.org are


