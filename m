Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AB7EB64DD
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbjG0UIE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjG0UHw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:07:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B2A2D63
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 13:07:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C986F61F25
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 20:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B58AC433C7;
        Thu, 27 Jul 2023 20:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488465;
        bh=zr6icEJseM9ylUrXP7LtNHz4b8eqRHthc7RV14K77Ys=;
        h=Date:To:From:Subject:From;
        b=wT6djyD629qO4S2ek8ay921WCalCT4IfJ6n77omHBbDH40HEun9JBewAVvrceJFNw
         e4WO9gl/SsdykTYT83xnCc2pz2ccK79MH31YYeZzWoVX1TNplCx/Jh5hIK/rPA+dQS
         bub3hH4Pd+r4mhbslKE35jaPeZUg2oZfw36gzTDk=
Date:   Thu, 27 Jul 2023 13:07:44 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, rdunlap@infradead.org,
        luca.ceresoli@bootlin.com, jszhang@kernel.org, irogers@google.com,
        guoren@kernel.org, didi.debian@cknow.org, conor@kernel.org,
        colin.i.king@gmail.com, dfustini@baylibre.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-spellingtxt-remove-thead-as-a-typo.patch removed from -mm tree
Message-Id: <20230727200745.2B58AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/spelling.txt: remove 'thead' as a typo
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-remove-thead-as-a-typo.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Drew Fustini <dfustini@baylibre.com>
Subject: scripts/spelling.txt: remove 'thead' as a typo
Date: Sat, 22 Jul 2023 18:03:30 -0700

T-Head is a vendor of processor core IP, and they have recently introduced
the RISC-V TH1520 SoC.  Remove 'thead' as a typo of 'thread' to avoid
checkpatch incorrectly warning that 'thead' is typo in patches that add
support for T-Head designs in the kernel.

Link: https://lkml.kernel.org/r/20230723010329.674186-1-dfustini@baylibre.com
Link: https://www.t-head.cn/
Signed-off-by: Drew Fustini <dfustini@baylibre.com>
Acked-by: Guo Ren <guoren@kernel.org>
Cc: Conor Dooley <conor@kernel.org>
Cc: Jisheng Zhang <jszhang@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Diederik de Haas <didi.debian@cknow.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com> # versaclock5
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-remove-thead-as-a-typo
+++ a/scripts/spelling.txt
@@ -1541,7 +1541,6 @@ temeprature||temperature
 temorary||temporary
 temproarily||temporarily
 temperture||temperature
-thead||thread
 theads||threads
 therfore||therefore
 thier||their
_

Patches currently in -mm which might be from dfustini@baylibre.com are


