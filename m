Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E30AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377803AbiATVXJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56220 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237238AbiATVXJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34746B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FD6C340E0;
        Thu, 20 Jan 2022 21:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713786;
        bh=R8RRutPJ+ltkL2Xkvpb3/IGorTkNImcB0BU6mL8qTqE=;
        h=Date:From:To:Subject:From;
        b=RCcOCaY5uzaMwf8zfeYYoBpyop3bY4sCzVgsjoXSSyrzLzoHaxukBFRI1MA35WZqV
         IGLm8eObCA02Y9E8TIzDzdrpR7dpWAMgHoyPi0lc568HipXx5XtqOTJLgpUTzZQpjD
         ijgk5tjmCOv+hfqebDtJFB3pqNwia8y7BOJBhOAc=
Date:   Thu, 20 Jan 2022 13:23:06 -0800
From:   akpm@linux-foundation.org
To:     colin.king@intel.com, dfustini@baylibre.com, gustavoars@kernel.org,
        mm-commits@vger.kernel.org, sven@narfation.org,
        tom.saeger@oracle.com, zuoqilin@yulong.com
Subject:  [merged] scripts-spellingtxt-add-oveflow.patch removed
 from -mm tree
Message-ID: <20220120212306.7FE8D6JxY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "oveflow"
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-oveflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Drew Fustini <dfustini@baylibre.com>
Subject: scripts/spelling.txt: add "oveflow"

Add typo "oveflow" for "overflow".  This typo was found and fixed in
tools/testing/selftests/bpf/prog_tests/btf_dump.c

Link: https://lore.kernel.org/all/20211122070528.837806-1-dfustini@baylibre.com/
Link: https://lkml.kernel.org/r/20211122072302.839102-1-dfustini@baylibre.com
Signed-off-by: Drew Fustini <dfustini@baylibre.com>
Suggested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Colin Ian King <colin.king@intel.com>
Cc: Drew Fustini <dfustini@baylibre.com>
Cc: zuoqilin <zuoqilin@yulong.com>
Cc: Tom Saeger <tom.saeger@oracle.com>
Cc: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-oveflow
+++ a/scripts/spelling.txt
@@ -1046,6 +1046,7 @@ oustanding||outstanding
 overaall||overall
 overhread||overhead
 overlaping||overlapping
+oveflow||overflow
 overflw||overflow
 overlfow||overflow
 overide||override
_

Patches currently in -mm which might be from dfustini@baylibre.com are


