Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E49C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B6B233FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgLPRKZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgLPRKZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:25 -0500
Date:   Wed, 16 Dec 2020 09:10:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138609;
        bh=ebwMrgL3N6d8Kccya8/FnH/H5whFxAov79/jXPvb5GU=;
        h=From:To:Subject:From;
        b=QwV8CQfMzspG4+r2vW2jFD7xydfXYYNag9NHkrGGd1OfYRkrb6U1LDLf9ItMLkLz/
         7PHBJz0KmBE0cgS2gVxiZ7Vs0J8VjOw8tNxJdvKD90V/dnZfRJnL/hTabBShYm2h1t
         ZnuptB8uecClnDWoxE0/QZrjSb0038Dwn4XpZmpI=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-fix-spelling-errors-and-remove-repeated-word.patch removed from
 -mm tree
Message-ID: <20201216171009.lm1N6px6w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix spelling errors and remove repeated word
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-spelling-errors-and-remove-repeated-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dwaipayanray1@gmail.com are


