Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BEFC77B76
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjDUVz2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbjDUVzW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E401FCB
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 637946533E
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAADC433EF;
        Fri, 21 Apr 2023 21:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682114120;
        bh=gMI7viD49cR5D1iNxtDmBcIeXDWzeSB7TaMMHPL3uTg=;
        h=Date:To:From:Subject:From;
        b=e36LmcWiixoxv9+QNlNqjE5oN7ISwW3z/5d2el/IzmsH3Z3sh+MNSXHiM4dIng6Nu
         aHyPYgWlUg2QJF3aaOPPNvV2WTB/qEe+L+zxCrMupYTO+n8b6MVHWD25FAanYqLZe2
         YuRc1Etz20mkgyVLyJrUZOx22CmRPEQP89vtx0H4=
Date:   Fri, 21 Apr 2023 14:55:20 -0700
To:     mm-commits@vger.kernel.org, kuba@kernel.org,
        konrad.dybcio@linaro.org, oleksandr@natalenko.name,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-add-entry-for-myself.patch removed from -mm tree
Message-Id: <20230421215520.BDAADC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entry for Oleksandr
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-myself.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: mailmap: add entry for Oleksandr
Date: Wed, 19 Apr 2023 15:47:34 +0200

Map my corporate email to my personal one.

Link: https://lkml.kernel.org/r/20230419134734.454630-1-oleksandr@natalenko.name
Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-myself
+++ a/.mailmap
@@ -354,6 +354,7 @@ Nicolas Pitre <nico@fluxnic.net> <nico@l
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.com>
 Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
+Oleksandr Natalenko <oleksandr@natalenko.name> <oleksandr@redhat.com>
 Oleksij Rempel <linux@rempel-privat.de> <bug-track@fisher-privat.net>
 Oleksij Rempel <linux@rempel-privat.de> <external.Oleksij.Rempel@de.bosch.com>
 Oleksij Rempel <linux@rempel-privat.de> <fixed-term.Oleksij.Rempel@de.bosch.com>
_

Patches currently in -mm which might be from oleksandr@natalenko.name are


