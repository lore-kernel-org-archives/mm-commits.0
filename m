Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B170FC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 22:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiJQWbe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 18:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiJQWbV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 18:31:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6588FFAE2
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 15:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71DB0B812A7
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 22:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B62EC433C1;
        Mon, 17 Oct 2022 22:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666045865;
        bh=jh6RtgKE+FMIEZfAwhvpass9nVxILtQjFPo4LPW0sW4=;
        h=Date:To:From:Subject:From;
        b=n/O3g1tHB9nDAxETj0kpQHYWDT8QsfY2sx6f5kBlkN2r6Iq1wVku1jtc91DPTVvUj
         y13qxuH9qeuC/Fl1lPtCPIeAze7fJ1YFvR3EDR6KargjI2CE/6ai86D4pvlrAMebah
         jcGiEfKmrQRswdmpr6f134F7ky4PlNiNVoA5RJJ0=
Date:   Mon, 17 Oct 2022 15:31:04 -0700
To:     mm-commits@vger.kernel.org, pvorel@suse.cz,
        conor.dooley@microchip.com, chrubis@suse.cz, palmer@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-git-github-https-githubcom-for-linux-test-project.patch added to mm-nonmm-unstable branch
Message-Id: <20221017223105.2B62EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: git://github -> https://github.com for linux-test-project
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-git-github-https-githubcom-for-linux-test-project.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-git-github-https-githubcom-for-linux-test-project.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Palmer Dabbelt <palmer@rivosinc.com>
Subject: MAINTAINERS: git://github -> https://github.com for linux-test-project
Date: Thu, 13 Oct 2022 14:46:38 -0700

Github deprecated the git:// links about a year ago, so let's move to
the https:// URLs instead.

Link: https://lkml.kernel.org/r/20221013214638.30953-1-palmer@rivosinc.com
Reported-by: Conor Dooley <conor.dooley@microchip.com>
  Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Cyril Hrubis <chrubis@suse.cz>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-git-github-https-githubcom-for-linux-test-project
+++ a/MAINTAINERS
@@ -12081,7 +12081,7 @@ M:	Alexey Kodanev <alexey.kodanev@oracle
 L:	ltp@lists.linux.it (subscribers-only)
 S:	Maintained
 W:	http://linux-test-project.github.io/
-T:	git git://github.com/linux-test-project/ltp.git
+T:	git https://github.com/linux-test-project/ltp.git
 
 LYNX 28G SERDES PHY DRIVER
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
_

Patches currently in -mm which might be from palmer@rivosinc.com are

maintainers-git-github-https-githubcom-for-linux-test-project.patch

