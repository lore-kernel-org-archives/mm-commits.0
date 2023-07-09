Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5370FEB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjGIAaj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjGIAaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4542CE55
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D631D60B46
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E61C433C8;
        Sun,  9 Jul 2023 00:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862628;
        bh=cNBG43Qjkm1zmd3+HO8SrjMueW40LteuhkRx5oHJWJo=;
        h=Date:To:From:Subject:From;
        b=d59y6RnMqGFpjTaJueltxfiqHlYbP0H8t6TQwEnHwPb2o4c5JqmM8LKxCNhH9P8ql
         pK0hHJbXH0lwphd/HAD27GOX/OKm8fMjJ56Foq6XbWGwnTBHw1qzIL7whbPaliiumZ
         eSCDwgbobuhd0Ez7tUsaaPVl4H7eN1L8pK038dL0=
Date:   Sat, 08 Jul 2023 17:30:27 -0700
To:     mm-commits@vger.kernel.org, heiko@sntech.de,
        heiko.stuebner@vrull.eu, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entries-for-heiko-stuebner.patch removed from -mm tree
Message-Id: <20230709003028.34E61C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entries for Heiko Stuebner
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-heiko-stuebner.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


