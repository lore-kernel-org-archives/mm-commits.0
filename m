Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBCBC7EE36
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 01:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjB1BBA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 20:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjB1BAy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 20:00:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD966298E7
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 17:00:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EFD060EF6
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 01:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49FCC4339B;
        Tue, 28 Feb 2023 01:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677546053;
        bh=ONEHZD2sToabpkfiCon4Su9IphGc+JSdl8QHcYeJWZ8=;
        h=Date:To:From:Subject:From;
        b=1k1rzZrvDmMrwz+McA+dHw0xtxtSmi9U/tJmNyJbNJURNhk13T3YhODlsv5OnfuUm
         Pt4nOcrocCUuIp6VFRrTdd0lJmo4VJpIV8v0GScuDX9ZLv2ZXnLWXpHrUT3wSZddTC
         tvOuexOX3R+nMDjAif335xsc6LQQWvIvas3a3GuQ=
Date:   Mon, 27 Feb 2023 17:00:52 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        qyousef@layalina.io, djakov@kernel.org, colin.i.king@gmail.com,
        baolin.wang@linux.alibaba.com, arnd@arndb.de,
        konrad.dybcio@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-georgi-djakovs-old-linaro-address-to-his-current-one.patch removed from -mm tree
Message-Id: <20230228010052.E49FCC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: map Georgi Djakov's old Linaro address to his current one
has been removed from the -mm tree.  Its filename was
     mailmap-map-georgi-djakovs-old-linaro-address-to-his-current-one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Konrad Dybcio <konrad.dybcio@linaro.org>
Subject: mailmap: map Georgi Djakov's old Linaro address to his current one
Date: Fri, 17 Feb 2023 21:35:16 +0100

Georgi's old email is still picked up by the likes of get_maintainer.pl
and it keeps bouncing every time one submits an interconnect patch.  Map
it to his current @kernel.org one.

Link: https://lkml.kernel.org/r/20230217203516.826424-1-konrad.dybcio@linaro.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Georgi Djakov <djakov@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
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


