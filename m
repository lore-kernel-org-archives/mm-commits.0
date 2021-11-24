Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6480FC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 02:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhKXDCW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237422AbhKXDCU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 22:02:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C784B60F45;
        Wed, 24 Nov 2021 02:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637722752;
        bh=QT4dLi0nUxK/JYriy1n1mz5wNSyFKMOzGpZM1b/G5PQ=;
        h=Date:From:To:Subject:From;
        b=ekp8q5PnXDFrN7r5A2GNHo5N8AIwa0M3cwuzqlIH0FiqSgmwot+52Rc6/a26CIEym
         1u8hsOxsep4RuVCUWOwiZpH1LJOusXiNI2GIU2DJvrFJSTJc6r1fZjG/E5S83aipaq
         u0CQm2SnmtG9j+Ln2FhkLP1EAf7CB9c3poGX1WR0=
Date:   Tue, 23 Nov 2021 18:59:11 -0800
From:   akpm@linux-foundation.org
To:     colin.king@intel.com, dfustini@baylibre.com, gustavoars@kernel.org,
        mm-commits@vger.kernel.org, sven@narfation.org,
        tangchunyou@yulong.com, tom.saeger@oracle.com, zuoqilin@yulong.com
Subject:  + scripts-spellingtxt-add-oveflow.patch added to -mm tree
Message-ID: <20211124025911.c_-xJ5i73%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "oveflow"
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-oveflow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-oveflow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-oveflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: tangchunyou <tangchunyou@yulong.com>
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

scripts-spellingtxt-add-oveflow.patch

