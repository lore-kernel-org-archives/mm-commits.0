Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00370C43462
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D02EC61181
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbhDIU1Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:27:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIU1Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C49A16115C;
        Fri,  9 Apr 2021 20:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000031;
        bh=qVuxJWwFpQIgD1n7i5u31PpDu3NCtxxqjIHJuu9jmas=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KWub/5bXVYi72DvKuWb/5AMUjOXs/rUJEgiau7qexgcLQCrubVDLSB1eQ8l2Vt6Qa
         NRCr/MBeIrs/9eOrdMhHwxIBwufQwVIvr8B4qJPHEa4A/96ocSCCL5U2nuHXF8ioxI
         7bUuSUl8RPvkH/A5lgbBcUqXfWhGjj1LLtna1KWQ=
Date:   Fri, 09 Apr 2021 13:27:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, nyc@holomorphy.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 04/16] .mailmap: fix old email addresses
Message-ID: <20210409202710.MmkDUuRkd%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Subject: .mailmap: fix old email addresses

Update Nick & Nadia's old addresses.

Link: https://lkml.kernel.org/r/20210406134036.GQ2531743@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/.mailmap~old-email-addresses-in-mailmap
+++ a/.mailmap
@@ -254,8 +254,14 @@ Morten Welinder <welinder@anemone.rentec
 Morten Welinder <welinder@darter.rentec.com>
 Morten Welinder <welinder@troll.com>
 Mythri P K <mythripk@ti.com>
+Nadia Yvette Chambers <nyc@holomorphy.com> William Lee Irwin III <wli@holomorphy.com>
 Nathan Chancellor <nathan@kernel.org> <natechancellor@gmail.com>
 Nguyen Anh Quynh <aquynh@gmail.com>
+Nicholas Piggin <npiggin@gmail.com> <npiggen@suse.de>
+Nicholas Piggin <npiggin@gmail.com> <npiggin@kernel.dk>
+Nicholas Piggin <npiggin@gmail.com> <npiggin@suse.de>
+Nicholas Piggin <npiggin@gmail.com> <nickpiggin@yahoo.com.au>
+Nicholas Piggin <npiggin@gmail.com> <piggin@cyberone.com.au>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
_
