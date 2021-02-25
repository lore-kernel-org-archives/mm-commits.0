Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51471C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CBC364F80
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhBYTOn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:14:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234361AbhBYTMM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:12:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9336464F1A;
        Thu, 25 Feb 2021 19:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280280;
        bh=IzKO0NFzXxDOABUZtzm2o3m0f0+nXZGDEpEiDrtV3mw=;
        h=Date:From:To:Subject:From;
        b=iwg3d7PlScA1SZa2TSGDyGg/rozPJOmWsDifOPpy/wU15pYARgepFrRL5ZFtZLzOk
         YPLgJ1erEbO1x/a/X9ns1RvzqFyWkdBj6V3h4wkOot8KXIoYFfphSqqlh68Row+ECE
         tLaOaKi1wi/2zTaQsBOdC4I5nvRZjehLh4Z8m1D4=
Date:   Thu, 25 Feb 2021 11:11:20 -0800
From:   akpm@linux-foundation.org
To:     dingsenjie@yulong.com, mm-commits@vger.kernel.org
Subject:  [merged]
 scripts-spellingtxt-add-allocted-and-exeeds-typo.patch removed from -mm
 tree
Message-ID: <20210225191120.7s1kB6-oV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "allocted" and "exeeds" typo
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-allocted-and-exeeds-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: dingsenjie <dingsenjie@yulong.com>
Subject: scripts/spelling.txt: add "allocted" and "exeeds" typo

Increase "allocted" and "exeeds" spelling error check.

Link: https://lkml.kernel.org/r/20210127081919.1928-1-dingsenjie@163.com
Signed-off-by: dingsenjie <dingsenjie@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-allocted-and-exeeds-typo
+++ a/scripts/spelling.txt
@@ -103,6 +103,7 @@ alloated||allocated
 allocatote||allocate
 allocatrd||allocated
 allocte||allocate
+allocted||allocated
 allpication||application
 alocate||allocate
 alogirhtms||algorithms
@@ -575,6 +576,7 @@ excellant||excellent
 execeeded||exceeded
 execeeds||exceeds
 exeed||exceed
+exeeds||exceeds
 exeuction||execution
 existance||existence
 existant||existent
_

Patches currently in -mm which might be from dingsenjie@yulong.com are


