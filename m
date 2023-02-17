Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDC5C05027
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 21:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBQVKY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Feb 2023 16:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBQVKX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2023 16:10:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AACD5D3EB
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 13:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF11CCE310E
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 21:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BCAC433D2;
        Fri, 17 Feb 2023 21:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676668218;
        bh=vi7CB75/hSAKqWm8DcMpNNFx9xDC/xKJYW1bZ6GAiWw=;
        h=Date:To:From:Subject:From;
        b=LbIjwQiXro5piAWz1t+S0sx+san1spuXZkt2ijBp/u89sHlQNQiSf97bRx0hz5goG
         kYFUz88+2f36mxjs7nt9I6UUQz8/i1K/UPEv7TsDNxe/obMP3N2KOqXBqkr354hFGT
         GjpyQy19y37Bmr5sPMwjHGXsolDcgt2PsVm+tYfI=
Date:   Fri, 17 Feb 2023 13:10:17 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        qyousef@layalina.io, djakov@kernel.org, colin.i.king@gmail.com,
        baolin.wang@linux.alibaba.com, arnd@arndb.de,
        konrad.dybcio@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-georgi-djakovs-old-linaro-address-to-his-current-one.patch added to mm-hotfixes-unstable branch
Message-Id: <20230217211018.A6BCAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: map Georgi Djakov's old Linaro address to his current one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-georgi-djakovs-old-linaro-address-to-his-current-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-georgi-djakovs-old-linaro-address-to-his-current-one.patch

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
From: Konrad Dybcio <konrad.dybcio@linaro.org>
Subject: mailmap: map Georgi Djakov's old Linaro address to his current one
Date: Fri, 17 Feb 2023 21:35:16 +0100

Georgi's old email is still picked up by the likes of get_maintainer.pl
and it keeps bouncing every time one submits an interconnect patch.  Map
it to his current @kernel.org one.

Link: https://lkml.kernel.org/r/20230217203516.826424-1-konrad.dybcio@linaro.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-map-georgi-djakovs-old-linaro-address-to-his-current-one
+++ a/.mailmap
@@ -150,6 +150,7 @@ Gao Xiang <xiang@kernel.org> <gaoxiang25
 Gao Xiang <xiang@kernel.org> <hsiangkao@aol.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@linux.alibaba.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@redhat.com>
+Georgi Djakov <djakov@kernel.org> <georgi.djakov@linaro.org>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <gerald.schaefer@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@linux.vnet.ibm.com>
_

Patches currently in -mm which might be from konrad.dybcio@linaro.org are

mailmap-map-georgi-djakovs-old-linaro-address-to-his-current-one.patch

