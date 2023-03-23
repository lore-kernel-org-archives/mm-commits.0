Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5635BC6FD1C
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCWBeQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCWBdk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B8EF968
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53C24623A2
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE601C433EF;
        Thu, 23 Mar 2023 01:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535138;
        bh=tap6JdveoGVOuWydoh0OilQdh9OBN3Mq+P4tumfItVI=;
        h=Date:To:From:Subject:From;
        b=UaD4AZGYedKjVq3COnHUXnLRgENj7HWC0pnXwTeVSH7uZF72MDfhX/aVqRFjEIZT5
         x1yNyjB2wdGAAYTBArYptB09G4ZKlSsNC04BQ8exXDIlWilvu1P6xZnrwdamduwjxF
         ggsFIst19y+W/dkxoKlbGzftXVYi2vGrJn41gDoQ=
Date:   Wed, 22 Mar 2023 18:32:18 -0700
To:     mm-commits@vger.kernel.org, tklauser@distanz.ch,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-tobias-klauser.patch removed from -mm tree
Message-Id: <20230323013218.AE601C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entry for Tobias Klauser
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-tobias-klauser.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: mailmap: add entry for Tobias Klauser
Date: Fri, 10 Mar 2023 13:35:08 +0100

Map my old email addresses to the current address.

Link: https://lkml.kernel.org/r/20230310123508.22079-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-add-entry-for-tobias-klauser
+++ a/.mailmap
@@ -426,6 +426,10 @@ Thomas Graf <tgraf@suug.ch>
 Thomas Körper <socketcan@esd.eu> <thomas.koerper@esd.eu>
 Thomas Pedersen <twp@codeaurora.org>
 Tiezhu Yang <yangtiezhu@loongson.cn> <kernelpatch@126.com>
+Tobias Klauser <tklauser@distanz.ch> <tobias.klauser@gmail.com>
+Tobias Klauser <tklauser@distanz.ch> <klto@zhaw.ch>
+Tobias Klauser <tklauser@distanz.ch> <tklauser@nuerscht.ch>
+Tobias Klauser <tklauser@distanz.ch> <tklauser@xenon.tklauser.home>
 Todor Tomov <todor.too@gmail.com> <todor.tomov@linaro.org>
 Tony Luck <tony.luck@intel.com>
 TripleX Chung <xxx.phy@gmail.com> <triplex@zh-kernel.org>
_

Patches currently in -mm which might be from tklauser@distanz.ch are


