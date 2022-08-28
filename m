Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBA4ECAAA2
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 21:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiH1VDZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Aug 2022 17:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiH1VDZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 28 Aug 2022 17:03:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC61D11C
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 14:03:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CF6B60E96
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 21:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837E1C433D6;
        Sun, 28 Aug 2022 21:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720603;
        bh=R7Clw9yjEowR5bMvXR1hBNivolqiTbHNtZ+Owh9R1Fk=;
        h=Date:To:From:Subject:From;
        b=OSJH6tWaG0/ENwOGu1uB4Fftascj060fqfEfYzgcDvs2TmFVfWxSH73T+UkH3jSyY
         Y3W620KPjWK+W9p1z+0mCJVubREv4Dzq/mVT24ONivQH9BVMWGmaXbI8iKgSIrzydh
         32vNfFgmhUoSSuSqlYYQU0LDGYM/CcNOTsTiKO+w=
Date:   Sun, 28 Aug 2022 14:03:22 -0700
To:     mm-commits@vger.kernel.org, gpiccoli@igalia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mailmap-update-guilherme-g-piccolis-email-addresses.patch removed from -mm tree
Message-Id: <20220828210323.837E1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update Guilherme G. Piccoli's email addresses
has been removed from the -mm tree.  Its filename was
     mailmap-update-guilherme-g-piccolis-email-addresses.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: mailmap: update Guilherme G. Piccoli's email addresses
Date: Thu, 4 Aug 2022 17:22:07 -0300

Both @canonical and @ibm email addresses are invalid now; use my personal
address instead.

Link: https://lkml.kernel.org/r/20220804202207.439427-1-gpiccoli@igalia.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-guilherme-g-piccolis-email-addresses
+++ a/.mailmap
@@ -150,6 +150,8 @@ Greg Kroah-Hartman <gregkh@suse.de>
 Greg Kroah-Hartman <greg@kroah.com>
 Greg Kurz <groug@kaod.org> <gkurz@linux.vnet.ibm.com>
 Gregory CLEMENT <gregory.clement@bootlin.com> <gregory.clement@free-electrons.com>
+Guilherme G. Piccoli <kernel@gpiccoli.net> <gpiccoli@linux.vnet.ibm.com>
+Guilherme G. Piccoli <kernel@gpiccoli.net> <gpiccoli@canonical.com>
 Guo Ren <guoren@kernel.org> <guoren@linux.alibaba.com>
 Guo Ren <guoren@kernel.org> <ren_guo@c-sky.com>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
_

Patches currently in -mm which might be from gpiccoli@igalia.com are


