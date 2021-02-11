Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6D4C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE5D64E66
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhBKSfC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 13:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232831AbhBKSc4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 13:32:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CCC364E8A;
        Thu, 11 Feb 2021 18:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068262;
        bh=kaW+GiKmha4DqFQPY8BtMuwwk1H8O+ytUhAmiBWyExs=;
        h=Date:From:To:Subject:From;
        b=R7n0SKaf8PojarVyFh9KWDY+gS5ccrJfekNdr3UaqVhpeK8FpjN54rPKsGc2CKBsW
         LME69MPG8K0Yo/HZUkvWFDYVqGYZw8znOPAFGfXAh993zVU5qjM48d7Q390W2W2xkp
         9w0R31z47zRurJRTWr4Wu12MlB0UBt/olUAyRyTI=
Date:   Thu, 11 Feb 2021 10:31:02 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  [merged]
 maintainers-update-andrey-ryabinins-email-address.patch removed from -mm
 tree
Message-ID: <20210211183102.VI3TxOP0k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Andrey Ryabinin's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-andrey-ryabinins-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


