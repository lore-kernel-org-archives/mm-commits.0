Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC78C2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2000023331
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgLPEpM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgLPEpM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:12 -0500
Date:   Tue, 15 Dec 2020 20:44:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093897;
        bh=fMni8/P/aatpC+qS0L37vTJm3XqxhFvjIo8jBDmSWAw=;
        h=From:To:Subject:In-Reply-To:From;
        b=uswgoNuLIxyjGkmTrxVqpm1/AGiNebezoykXnjz6dmZCM4agtIuSI3vzWkNARQJ91
         uC5ZvlTJ3XOILbxmMHSL5lZrL1ztDfp1o59SoA8sdKz9AAaYinrUGMFTVy/IF5J/sD
         zi3X7dBT2Ap5KfhfMlz+em/4LDHoY82dQMFbu9VY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 48/95] checkpatch: fix spelling errors and remove
 repeated word
Message-ID: <20201216044456.AcprlOOeP%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: fix spelling errors and remove repeated word

Delete repeated word in scripts/checkpatch.pl:
"are are" -> "are"

Fix typos:
"commments" -> "comments"
"falsly" -> "falsely"

Link: https://lkml.kernel.org/r/20201113152316.62975-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-spelling-errors-and-remove-repeated-word
+++ a/scripts/checkpatch.pl
@@ -2841,7 +2841,7 @@ sub process {
 
 
 				# stable@vger.kernel.org or stable@kernel.org shouldn't
-				# have an email name. In addition commments should strictly
+				# have an email name. In addition comments should strictly
 				# begin with a #
 				if ($email =~ /^.*stable\@(?:vger\.)?kernel\.org/i) {
 					if (($comment ne "" && $comment !~ /^#.+/) ||
@@ -5000,7 +5000,7 @@ sub process {
 ## 		    $line !~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Type\s*$Ident.*/) {
 ##
 ## 			# Remove any bracketed sections to ensure we do not
-## 			# falsly report the parameters of functions.
+## 			# falsely report the parameters of functions.
 ## 			my $ln = $line;
 ## 			while ($ln =~ s/\([^\(\)]*\)//g) {
 ## 			}
@@ -7109,7 +7109,7 @@ sub process {
 		exit(0);
 	}
 
-	# This is not a patch, and we are are in 'no-patch' mode so
+	# This is not a patch, and we are in 'no-patch' mode so
 	# just keep quiet.
 	if (!$chk_patch && !$is_patch) {
 		exit(0);
_
