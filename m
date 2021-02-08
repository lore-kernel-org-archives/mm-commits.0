Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D6CC43381
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8195864E6C
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhBHRZa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 12:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233036AbhBHRXm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 12:23:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930E964E45;
        Mon,  8 Feb 2021 17:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612804878;
        bh=AarBXLPUktJd9ZLDpY38vwcKCeTkJ0mmbE7lYrdRsKU=;
        h=Date:From:To:Subject:From;
        b=GOqGCWIFj4hjq0AP2BiMxaXMhK66yMnqlCBA2OOOinjwrhUsaNeoKJgTudSUEn4ql
         hYbVVKwTxE25ck+vk4dwUHvzaUKaTUpLrUWxQJo5V2JZ+harp2yPIfLF/fRKbx894W
         wMizhj0R1Qg46mw0jsytNzAlvq6hx23B4HcFOa9M=
Date:   Mon, 08 Feb 2021 09:21:18 -0800
From:   akpm@linux-foundation.org
To:     lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, ojeda@kernel.org,
        sedat.dilek@gmail.com
Subject:  [merged]
 maintainers-mailmap-use-my-kernelorg-address.patch removed from -mm tree
Message-ID: <20210208172118.2g81ZlI3k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS/.mailmap: use my @kernel.org address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-use-my-kernelorg-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from nathan@kernel.org are


