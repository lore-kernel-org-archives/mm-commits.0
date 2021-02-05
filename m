Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27E7C433E6
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA4F64FA8
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhBFDOs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232386AbhBFC44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 21:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB48A64E0A;
        Fri,  5 Feb 2021 22:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612564936;
        bh=lz2d7DouIlArTMmw0udTOaj7Le3i2OoPRCmSmFxVyvA=;
        h=Date:From:To:Subject:From;
        b=gNIGrn5H7wWJqRvGnI1D7fYXNUrda+MkRXinWkSJh/kv395D4rDMxwluVQjxomQRZ
         5SxYMCIwEAfnZUcefo+U6gNGOpcY48sU1Mor6S+mOENhruk1JjwqTGGuhIGpuGusSB
         bdSt4bawwDl9qemYyy3tLEZIXEdkme6DlH6aejLo=
Date:   Fri, 05 Feb 2021 14:42:16 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  + maintainers-update-andrey-ryabinins-email-address.patch
 added to -mm tree
Message-ID: <20210205224216.fsAc3RUcl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Andrey Ryabinin's email address
has been added to the -mm tree.  Its filename is
     maintainers-update-andrey-ryabinins-email-address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-andrey-ryabinins-email-address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-andrey-ryabinins-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: MAINTAINERS: update Andrey Ryabinin's email address

Update my email, @virtuozzo.com will stop working shortly.

Link: https://lkml.kernel.org/r/20210204223904.3824-1-ryabinin.a.a@gmail.com
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-andrey-ryabinins-email-address
+++ a/.mailmap
@@ -37,6 +37,7 @@ Andrew Murray <amurray@thegoodpenguin.co
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
 Andrew Vasquez <andrew.vasquez@qlogic.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <a.ryabinin@samsung.com>
+Andrey Ryabinin <ryabinin.a.a@gmail.com> <aryabinin@virtuozzo.com>
 Andy Adamson <andros@citi.umich.edu>
 Antoine Tenart <atenart@kernel.org> <antoine.tenart@bootlin.com>
 Antoine Tenart <atenart@kernel.org> <antoine.tenart@free-electrons.com>
--- a/MAINTAINERS~maintainers-update-andrey-ryabinins-email-address
+++ a/MAINTAINERS
@@ -9559,7 +9559,7 @@ F:	Documentation/hwmon/k8temp.rst
 F:	drivers/hwmon/k8temp.c
 
 KASAN
-M:	Andrey Ryabinin <aryabinin@virtuozzo.com>
+M:	Andrey Ryabinin <ryabinin.a.a@gmail.com>
 R:	Alexander Potapenko <glider@google.com>
 R:	Dmitry Vyukov <dvyukov@google.com>
 L:	kasan-dev@googlegroups.com
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are

maintainers-update-andrey-ryabinins-email-address.patch

