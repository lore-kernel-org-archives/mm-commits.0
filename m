Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22792C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E47961108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhKKCvY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234449AbhKKCvX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9243360F26;
        Thu, 11 Nov 2021 02:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598915;
        bh=Em+0eZvI8b5slqE25jLFr0yUJ7rQ4y0GTkLfkgs5niI=;
        h=Date:From:To:Subject:From;
        b=tV8E+gMe6pOEEPHxs2V3FnBt5UaarZ2BosIWgYvotLyONCKUPIpskdJ7y2YjaCn0E
         sI4PQvdi0Z50aHRhuFVj7iqc4EfvqpTB3JI8//SWXDlfG4bJdTcAqt/iP8hFDlJOQt
         kECdchcHDzS+tBN3KotC4KjcqTKacOH+qvWusL2Y=
Date:   Wed, 10 Nov 2021 18:48:35 -0800
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject:  [merged] mm-damon-grammar-s-works-work.patch removed from
 -mm tree
Message-ID: <20211111024835.6fhrXITDh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: grammar s/works/work/
has been removed from the -mm tree.  Its filename was
     mm-damon-grammar-s-works-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from geert@linux-m68k.org are


