Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6633BC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A9BA64E85
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhBXUBc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:01:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233313AbhBXUBC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:01:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 063FD64E6C;
        Wed, 24 Feb 2021 20:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196822;
        bh=I2VSNTV4crk2ImvnlU5ZAPKjEZLebQlg7USVoOG/bqg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=a2MF/nE2n0D8kythNJpBB1YI6zavFccFrQtck9FHCuoNMnNV6R93syjJK1wnPneXx
         O3PRopLHkPlZ+W/xmfTZYjqECqmRYdSXlLltLVBRS3jknjlnX1qItE44uPNI1myd5v
         OP8zA8MKOkwqreTb9AxbVnbcDF8LWCBxNCZIL5hY=
Date:   Wed, 24 Feb 2021 12:00:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dingsenjie@yulong.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 004/173] scripts/spelling.txt: add "allocted" and
 "exeeds" typo
Message-ID: <20210224200021.P8tnAV7L0%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
