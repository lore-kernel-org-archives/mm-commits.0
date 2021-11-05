Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A48C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCEB761357
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhKEUse (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233705AbhKEUsd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D354061288;
        Fri,  5 Nov 2021 20:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145153;
        bh=rL52ULhCpJPKDrV0HcLGjKlhZHRqkX1Z7SGLcEe0MKo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=osFsDVIrxFYg/hLzLU0UDf9bESj2tduIVq5UYWfoiysND2mJlPCJhuksYmOtExcdf
         XgJs2TpxPAXTHJ0fcRIrZLwyj77VmwZ0L6kdvoHOdGmizFeOUyz3+ewAqYFUQupoIk
         IviNQYM3PykVl3BGaKzAhEsWid/bR1wIeLH5YAd0=
Date:   Fri, 05 Nov 2021 13:45:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, geert@linux-m68k.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org
Subject:  [patch 214/262] mm/damon: grammar s/works/work/
Message-ID: <20211105204552.aPJCALJw7%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm/damon: grammar s/works/work/

Correct a singular versus plural grammar mistake in the help text for the
DAMON_VADDR config symbol.

Link: https://lkml.kernel.org/r/20210914073451.3883834-1-geert@linux-m68k.org
Fixes: 3f49584b262cf8f4 ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-grammar-s-works-work
+++ a/mm/damon/Kconfig
@@ -30,7 +30,7 @@ config DAMON_VADDR
 	select PAGE_IDLE_FLAG
 	help
 	  This builds the default data access monitoring primitives for DAMON
-	  that works for virtual address spaces.
+	  that work for virtual address spaces.
 
 config DAMON_VADDR_KUNIT_TEST
 	bool "Test for DAMON primitives" if !KUNIT_ALL_TESTS
_
