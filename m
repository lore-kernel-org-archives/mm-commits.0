Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF97C6FA8E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjCCCNm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCCCNl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:13:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45D234C2A
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:13:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78DC2B81644
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C419C433D2;
        Fri,  3 Mar 2023 02:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677809616;
        bh=PqHBZdus5rVcYMfhInTBU0s1NdlC8VLt5sLJanOlpfA=;
        h=Date:To:From:Subject:From;
        b=gtYdz+VRV/kH5Kc2surATHTZaGja9wEVzBb+hHAr3VYoTxnelAcjlMtacYgbM3xRW
         Ra7AC5j9qPUkHcc3yTdC8Eh5PAq1vedSTmrR2wfpfG68QasuEN6/7KNOyImXgkUJhc
         3AGVGxUoJSw9rjKNJl0/mwsdFlT51mfVlBpBGqsg=
Date:   Thu, 02 Mar 2023 18:13:35 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        qyousef@layalina.io, colin.i.king@gmail.com, bwidawsk@kernel.org,
        baolin.wang@linux.alibaba.com, arnd@arndb.de, andersson@kernel.org,
        jarkko@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-updates-for-jarkko-sakkinen.patch added to mm-hotfixes-unstable branch
Message-Id: <20230303021336.0C419C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: updates for Jarkko Sakkinen
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-updates-for-jarkko-sakkinen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-updates-for-jarkko-sakkinen.patch

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
@@ -190,6 +190,7 @@ Jan Glauber <jan.glauber@gmail.com> <jan
 Jan Glauber <jan.glauber@gmail.com> <jglauber@cavium.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
+Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@tuni.fi>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are

mailmap-updates-for-jarkko-sakkinen.patch

