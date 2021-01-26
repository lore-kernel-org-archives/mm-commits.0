Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B819DC43381
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E172206FB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 02:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhA0Cso (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 21:48:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbhAZVoo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 16:44:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7EEB2053B;
        Tue, 26 Jan 2021 21:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611697442;
        bh=PkMGDLKHFWOy0Z0+7FMAAb/+iIp71C310hMqxvRuh5Y=;
        h=Date:From:To:Subject:From;
        b=so/Etp4Xek8CSZVrqQFjulIG20YKT81pGEk9NwgJqgxDSZZ9x1KtjIk7YdoDMGUEl
         caA7Umz2dPRYmXLgAqdxFT3m9W/LuJ/8NcFVhfsRjCvi8OGoswS/1NnqKiTURHZFE6
         Pn/op2DoqW4w4I3cjepkaJWrSiTH5O9ae3UXu5ds=
Date:   Tue, 26 Jan 2021 13:44:02 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Subject:  + maintainers-mailmap-use-my-kernelorg-address.patch
 added to -mm tree
Message-ID: <20210126214402.VPUMyIg2H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS/.mailmap: use my @kernel.org address
has been added to the -mm tree.  Its filename is
     maintainers-mailmap-use-my-kernelorg-address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-mailmap-use-my-kernelorg-address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-mailmap-use-my-kernelorg-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: MAINTAINERS/.mailmap: use my @kernel.org address

Use my @kernel.org for all points of contact so that I am always
accessible.

Link: https://lkml.kernel.org/r/20210126212730.2097108-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-use-my-kernelorg-address
+++ a/.mailmap
@@ -247,6 +247,7 @@ Morten Welinder <welinder@anemone.rentec
 Morten Welinder <welinder@darter.rentec.com>
 Morten Welinder <welinder@troll.com>
 Mythri P K <mythripk@ti.com>
+Nathan Chancellor <nathan@kernel.org> <natechancellor@gmail.com>
 Nguyen Anh Quynh <aquynh@gmail.com>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
--- a/MAINTAINERS~maintainers-mailmap-use-my-kernelorg-address
+++ a/MAINTAINERS
@@ -4303,7 +4303,7 @@ S:	Maintained
 F:	.clang-format
 
 CLANG/LLVM BUILD SUPPORT
-M:	Nathan Chancellor <natechancellor@gmail.com>
+M:	Nathan Chancellor <nathan@kernel.org>
 M:	Nick Desaulniers <ndesaulniers@google.com>
 L:	clang-built-linux@googlegroups.com
 S:	Supported
_

Patches currently in -mm which might be from nathan@kernel.org are

maintainers-mailmap-use-my-kernelorg-address.patch

