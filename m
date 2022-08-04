Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6E0C25B06
	for <mm-commits@archiver.kernel.org>; Thu,  4 Aug 2022 22:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbiHDWcI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Aug 2022 18:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiHDWcI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2022 18:32:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B0332BA2
        for <mm-commits@vger.kernel.org>; Thu,  4 Aug 2022 15:32:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 944C4B82768
        for <mm-commits@vger.kernel.org>; Thu,  4 Aug 2022 22:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A38BC433C1;
        Thu,  4 Aug 2022 22:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659652324;
        bh=ifpbSZ316NFuU6ujkb3ZzTeyk1+18uOfNo47qdvZEW8=;
        h=Date:To:From:Subject:From;
        b=OdsOoj+332bJfRiPnL/qJ9YpES7KMTAygGRMcfx5Je56R2lJWW/bN7NsdVg+ABjD/
         vAkuHH9f4TdRosYVvnZA+TJ2VH7ltWoIPaSgVecvinBcVomiydRXdhL9hHeS1TsNOD
         cP/xLNX+0VpzGAOJOzsvEYCA7u3w/PIvYi852mGY=
Date:   Thu, 04 Aug 2022 15:32:03 -0700
To:     mm-commits@vger.kernel.org, gpiccoli@igalia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-guilherme-g-piccolis-email-addresses.patch added to mm-hotfixes-unstable branch
Message-Id: <20220804223204.1A38BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Guilherme G. Piccoli's email addresses
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-guilherme-g-piccolis-email-addresses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-guilherme-g-piccolis-email-addresses.patch

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
@@ -142,6 +142,8 @@ Greg Kroah-Hartman <gregkh@suse.de>
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

mailmap-update-guilherme-g-piccolis-email-addresses.patch

