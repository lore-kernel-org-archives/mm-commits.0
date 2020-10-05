Return-Path: <SRS0=fIDE=DM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E89C4727D
	for <mm-commits@archiver.kernel.org>; Mon,  5 Oct 2020 23:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B680A207F7
	for <mm-commits@archiver.kernel.org>; Mon,  5 Oct 2020 23:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601940150;
	bh=vTDkCKD4SZQ7DBRPtboSwKl2j/IrGBCbGZf2uciGbf8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=m2J8yzSJOjU/9wDRLNHyxJhv0KwEQ2fYsLltWJ47+JDB5v8Sg5OoCF4iWv6rxvPDf
	 zinhhrBuafRttxQp9+S/8LBQ0xq1lpvHmsZluNqWdRbrzmN91d3ICBluHOm02Sth9S
	 N/g4suPfjxvy9wea3d8CptsMObfc84DdL9el7130=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgJEXV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Oct 2020 19:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgJEXVp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Oct 2020 19:21:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 718D7206B5;
        Mon,  5 Oct 2020 23:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601940103;
        bh=vTDkCKD4SZQ7DBRPtboSwKl2j/IrGBCbGZf2uciGbf8=;
        h=Date:From:To:Subject:From;
        b=ggUPrRysOD5yKNIBIptcLAXfein8uZj4V0Bq+TpTV10Ucr2PCnotzzbwQ1Xsbxqg3
         7wH3DVged5YJsFfjVqSDtVmY/w/0iTaCkeBlqPw+pGhZ7qVGM8PU2QYT4XHmE4EDom
         Q/eXpMifxgVZQYT7soDgPMVZWYjNzNX6FVRQiGNQ=
Date:   Mon, 05 Oct 2020 16:21:43 -0700
From:   akpm@linux-foundation.org
To:     ebiggers@google.com, mm-commits@vger.kernel.org
Subject:  [merged] scripts-spellingtxt-fix-malformed-entry.patch
 removed from -mm tree
Message-ID: <20201005232143.NrQJ7ZgrN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: fix malformed entry
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-fix-malformed-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: scripts/spelling.txt: fix malformed entry

One of the entries has three fields "mistake||correction||correction"
rather than the expected two fields "mistake||correction".  Fix it.

Link: https://lkml.kernel.org/r/20200930234359.255295-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-fix-malformed-entry
+++ a/scripts/spelling.txt
@@ -589,7 +589,7 @@ explictly||explicitly
 expresion||expression
 exprimental||experimental
 extened||extended
-exteneded||extended||extended
+exteneded||extended
 extensability||extensibility
 extention||extension
 extenstion||extension
_

Patches currently in -mm which might be from ebiggers@google.com are


