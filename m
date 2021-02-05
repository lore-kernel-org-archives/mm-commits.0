Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6BFC433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33D5464FB6
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhBECdb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:33:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230224AbhBECd1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E3B164FB6;
        Fri,  5 Feb 2021 02:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492384;
        bh=i6vFZTmDDAZQydCvKi19Ruz/+P5zxR39oM7qUkFTlJQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WL5CLyXl2nuVMWZRDAdEAr2+iQZ+Lg4KsVk5v3QhyU4Zk4jd+71ZWjAAeXyozJSZs
         /byTb/bGqWOY28a7VrxoAqDXg+FOcxd/lPOzGjqO2j+xoAD9AZqV7ThQ5dn7GooUUy
         ueYZiDo0qSYZeaLbDFidFTk4qg8lQE2a8DCiHmFA=
Date:   Thu, 04 Feb 2021 18:33:03 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, ojeda@kernel.org,
        sedat.dilek@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 18/18] MAINTAINERS/.mailmap: use my @kernel.org
 address
Message-ID: <20210205023303.e5190okmD%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>
Subject: MAINTAINERS/.mailmap: use my @kernel.org address

Use my @kernel.org for all points of contact so that I am always
accessible.

Link: https://lkml.kernel.org/r/20210126212730.2097108-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-use-my-kernelorg-address
+++ a/.mailmap
@@ -246,6 +246,7 @@ Morten Welinder <welinder@anemone.rentec
 Morten Welinder <welinder@darter.rentec.com>
 Morten Welinder <welinder@troll.com>
 Mythri P K <mythripk@ti.com>
+Nathan Chancellor <nathan@kernel.org> <natechancellor@gmail.com>
 Nguyen Anh Quynh <aquynh@gmail.com>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
--- a/MAINTAINERS~maintainers-mailmap-use-my-kernelorg-address
+++ a/MAINTAINERS
@@ -4304,7 +4304,7 @@ S:	Maintained
 F:	.clang-format
 
 CLANG/LLVM BUILD SUPPORT
-M:	Nathan Chancellor <natechancellor@gmail.com>
+M:	Nathan Chancellor <nathan@kernel.org>
 M:	Nick Desaulniers <ndesaulniers@google.com>
 L:	clang-built-linux@googlegroups.com
 S:	Supported
_
