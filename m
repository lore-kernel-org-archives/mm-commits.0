Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC138C43217
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA0E1611C4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244755AbhIIVFi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348518AbhIIVEh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D15361179;
        Thu,  9 Sep 2021 21:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221407;
        bh=wVYf0BK0Upr7H95pwEk01iTJnsJ5MN/IpD6WhZzEQvM=;
        h=Date:From:To:Subject:From;
        b=2nymarlbThEkXx9oLSSo4sM6W0HIwhZG0df8GaCTQnl5jeJYok7eiLP5TcouvVY9C
         aBAYgpFbZ08erj2RI+NZXgIrW8D0850LYqk6yAGZODAZh+3GfmoDWrxff96zKLmmKW
         f1R/0BI9NsGvmTS8XYz8oy60Zh+twL7dp+fhO2iU=
Date:   Thu, 09 Sep 2021 14:03:27 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  [merged]
 arch-kconfig-fix-spelling-mistake-seperate-separate.patch removed from -mm
 tree
Message-ID: <20210909210327.hzKxa0QQt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch: Kconfig: fix spelling mistake "seperate" -> "separate"
has been removed from the -mm tree.  Its filename was
     arch-kconfig-fix-spelling-mistake-seperate-separate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: arch: Kconfig: fix spelling mistake "seperate" -> "separate"

Threre is a spelling mistake in the Kconfig text. Fix it.

Link: https://lkml.kernel.org/r/20210704095207.37342-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/Kconfig~arch-kconfig-fix-spelling-mistake-seperate-separate
+++ a/arch/Kconfig
@@ -886,7 +886,7 @@ config HAVE_SOFTIRQ_ON_OWN_STACK
 	bool
 	help
 	  Architecture provides a function to run __do_softirq() on a
-	  seperate stack.
+	  separate stack.
 
 config PGTABLE_LEVELS
 	int
_

Patches currently in -mm which might be from colin.king@canonical.com are


