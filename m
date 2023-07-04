Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE8AEB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 17:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjGDRJ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 13:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjGDRJY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 13:09:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0B610D5
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 10:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 793D061321
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 17:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4A5C433C7;
        Tue,  4 Jul 2023 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688490560;
        bh=WvBbWyOP2gpCPaQbQa+y/tURrk0xGTSLyjuxNxdkHPU=;
        h=Date:To:From:Subject:From;
        b=lD5V6rxE8efnxB4gZTiZqaP6nzAkXocpCwpQ1uLZdm9jRaScXbAIhphNVMjSWvQ/G
         0GAlRf/xSH6aLo8myigQb+ZeQAuIiiITMbvaF2G4nkGkKxA5dfyPIUDOpzX3UsaNxJ
         KSfWf91lYT0kJgwMyTgmPNAYedAcUlKR9hM4l+mA=
Date:   Tue, 04 Jul 2023 10:09:20 -0700
To:     mm-commits@vger.kernel.org, heiko@sntech.de,
        heiko.stuebner@vrull.eu, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-heiko-stuebner.patch added to mm-hotfixes-unstable branch
Message-Id: <20230704170920.CE4A5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entries for Heiko Stuebner
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-heiko-stuebner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-heiko-stuebner.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: mailmap: add entries for Heiko Stuebner
Date: Tue, 4 Jul 2023 18:39:19 +0200

I am going to lose my vrull.eu address at the end of july, and while
adding it to mailmap I also realised that there are more old addresses
from me dangling, so update .mailmap for all of them.

Link: https://lkml.kernel.org/r/20230704163919.1136784-3-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-heiko-stuebner
+++ a/.mailmap
@@ -178,6 +178,9 @@ Gustavo Padovan <padovan@profusion.mobi>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
+Heiko Stuebner <heiko@sntech.de> <heiko.stuebner@bqreaders.com>
+Heiko Stuebner <heiko@sntech.de> <heiko.stuebner@theobroma-systems.com>
+Heiko Stuebner <heiko@sntech.de> <heiko.stuebner@vrull.eu>
 Henk Vergonet <Henk.Vergonet@gmail.com>
 Henrik Kretzschmar <henne@nachtwindheim.de>
 Henrik Rydberg <rydberg@bitmath.org>
_

Patches currently in -mm which might be from heiko.stuebner@vrull.eu are

mailmap-update-manpage-link.patch
mailmap-add-entries-for-heiko-stuebner.patch

