Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891B4C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BBCE613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWj7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWj7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8253B610D2;
        Sat,  8 May 2021 22:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513536;
        bh=XzTmIYhvGQ37uqAAK/qCY7RwKON56mlpOwS9sT1XfH0=;
        h=Date:From:To:Subject:From;
        b=w8xRByKWX3GR1dlXCQR2NPIAFItNDrldIOdzPjHNIwZh7nzEimA145ld5mIw2kZsp
         bcneJy9ADW4Fuf7w0dSnPKnbmwJljf4fOiRPmaDTwpMeIZZ9RjEZffcShCaT29Uyfb
         3MWMfzIz011Sp1EKztiinE0oJ1eRsarRzdEetHC0=
Date:   Sat, 08 May 2021 15:38:56 -0700
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, unixbhaskar@gmail.com
Subject:  [merged]
 ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch removed from -mm tree
Message-ID: <20210508223856.h5tSm_8-a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/kernel/fsys.S: fix typos
has been removed from the -mm tree.  Its filename was
     ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: arch/ia64/kernel/fsys.S: fix typos

Mundane spelling fixes.

Link: https://lkml.kernel.org/r/20210311061058.29492-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/fsys.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/ia64/kernel/fsys.S~ia64-kernel-few-typos-fixed-in-the-file-fsyss
+++ a/arch/ia64/kernel/fsys.S
@@ -172,7 +172,7 @@ ENTRY(fsys_gettimeofday)
 	// r25 = itc_lastcycle value
 	// r26 = address clocksource cycle_last
 	// r27 = (not used)
-	// r28 = sequence number at the beginning of critcal section
+	// r28 = sequence number at the beginning of critical section
 	// r29 = address of itc_jitter
 	// r30 = time processing flags / memory address
 	// r31 = pointer to result
@@ -432,7 +432,7 @@ GLOBAL_ENTRY(fsys_bubble_down)
 	 *	- r29: psr
 	 *
 	 * We used to clear some PSR bits here but that requires slow
-	 * serialization.  Fortuntely, that isn't really necessary.
+	 * serialization.  Fortunately, that isn't really necessary.
 	 * The rationale is as follows: we used to clear bits
 	 * ~PSR_PRESERVED_BITS in PSR.L.  Since
 	 * PSR_PRESERVED_BITS==PSR.{UP,MFL,MFH,PK,DT,PP,SP,RT,IC}, we
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are


