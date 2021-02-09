Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174CAC433E6
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 22:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2A7D64DEE
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 22:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhBIW1o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 17:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233984AbhBIWMP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 17:12:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E184D64ED9;
        Tue,  9 Feb 2021 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906945;
        bh=vV7Xnf8LWXtlXGOFXAz8nKs1+d8VhdXcil6iddTY3o0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yeChl2tO72RCOkDQadvhYkqGnF9ZSpEA5CgsUc+czyr9yfwsITD5bC7iAM0BBgLN2
         CMbYKDNOmBLA4v47o3k4FTBg76ZZHXEzaHjkmNV0F2SKuCRZBqqXzpt8cZgm79XQBu
         oJFfMjtenF1UKrN/7Bi15XdRqY2Abuk3EKUnmxAU=
Date:   Tue, 09 Feb 2021 13:42:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 11/14] MAINTAINERS: update Andrey Ryabinin's email
 address
Message-ID: <20210209214224.8JRtCT_1R%akpm@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
