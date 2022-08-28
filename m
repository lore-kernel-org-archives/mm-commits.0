Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65944C64991
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 21:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiH1VFN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Aug 2022 17:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiH1VDo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 28 Aug 2022 17:03:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16BE3136C
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 14:03:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A167B80BA5
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 21:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EA0C433D6;
        Sun, 28 Aug 2022 21:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720620;
        bh=slZx6AU7Wi4Xh1ia5tFDmyIc7cjwoE/mIKefOdGJ2DM=;
        h=Date:To:From:Subject:From;
        b=gcektKpRBMLdwqyY7PKM3a6r4ZU3UZ812Itnk9YxYbBqZa1Mc+V179CVyw2ug8GLo
         rVeTrvX8DJjsWl8K/jWFNV4RYCReZyJ0pEV0AhAjTKsafkRkZqyMv8tktYslf9ZByN
         rYlEwcyDlxxREoS3l/RVDLQuma0Daj4QsRj2gtr4=
Date:   Sun, 28 Aug 2022 14:03:39 -0700
To:     mm-commits@vger.kernel.org, thomas.petazzoni@bootlin.com,
        hverkuil-cisco@xs4all.nl, atishp@atishpatra.org, arnd@arndb.de,
        luca.ceresoli@bootlin.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mailmap-update-luca-ceresolis-e-mail-address.patch removed from -mm tree
Message-Id: <20220828210340.25EA0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: .mailmap: update Luca Ceresoli's e-mail address
has been removed from the -mm tree.  Its filename was
     mailmap-update-luca-ceresolis-e-mail-address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: .mailmap: update Luca Ceresoli's e-mail address
Date: Fri, 26 Aug 2022 15:05:15 +0200

My Bootlin address is preferred from now on.

Link: https://lkml.kernel.org/r/20220826130515.3011951-1-luca.ceresoli@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Atish Patra <atishp@atishpatra.org>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-luca-ceresolis-e-mail-address
+++ a/.mailmap
@@ -254,6 +254,7 @@ Linus Lüssing <linus.luessing@c0d3.blue
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lorenzo Pieralisi <lpieralisi@kernel.org> <lorenzo.pieralisi@arm.com>
+Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Maciej W. Rozycki <macro@mips.com> <macro@imgtec.com>
 Maciej W. Rozycki <macro@orcam.me.uk> <macro@linux-mips.org>
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are


