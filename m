Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1784C678D5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 01:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCHBFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 20:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjCHBFd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 20:05:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC96AA4020
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 17:05:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50E11B81B50
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 01:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E2BC433D2;
        Wed,  8 Mar 2023 01:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678237529;
        bh=ou9iW2Zaumggv5s7grRv3sMIKE1xTwjg9HcKneus6ck=;
        h=Date:To:From:Subject:From;
        b=XIldHhvOEjvxKJ3FpPdVHsyn6/cxGp2KoDPXDgQ/RTsOtsxIltz59njmIy3rnw/mO
         CaqEekQGrOykbGt+OD1srFqlScUz1knGfIsKT6rxj5GgvVil4t64sgkgb3UeTn2ZCy
         Ev5W5bhRuObigPvczqhpVnSEKVKwuEMC33pSKyn8=
Date:   Tue, 07 Mar 2023 17:05:28 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        qyousef@layalina.io, colin.i.king@gmail.com, bwidawsk@kernel.org,
        baolin.wang@linux.alibaba.com, arnd@arndb.de, andersson@kernel.org,
        jarkko@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-updates-for-jarkko-sakkinen.patch removed from -mm tree
Message-Id: <20230308010529.03E2BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: updates for Jarkko Sakkinen
has been removed from the -mm tree.  Its filename was
     mailmap-updates-for-jarkko-sakkinen.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: mailmap: updates for Jarkko Sakkinen
Date: Thu, 2 Mar 2023 01:54:42 +0200

Update to my current employer:

https://research.tuni.fi/nisec/

Link: https://lkml.kernel.org/r/20230301235443.6663-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ben Widawsky <bwidawsk@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-updates-for-jarkko-sakkinen
+++ a/.mailmap
@@ -191,6 +191,7 @@ Jan Glauber <jan.glauber@gmail.com> <jan
 Jan Glauber <jan.glauber@gmail.com> <jglauber@cavium.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
+Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@tuni.fi>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are


