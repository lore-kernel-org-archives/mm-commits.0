Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22207C6FA99
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 01:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCHBFk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 20:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjCHBFg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 20:05:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A37A4020
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 17:05:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06FE0CE1DE1
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 01:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B59C433D2;
        Wed,  8 Mar 2023 01:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678237531;
        bh=axrJzB8LxcXAvByzRm1l8HjZsw67dKZd6YNccCcO00Q=;
        h=Date:To:From:Subject:From;
        b=pVVfRBaKjkhKxwHU5HTTpQdE3FNNsQMU6nGyz+H+I77Y5oLOu7Rb7x0srKXeTFdQO
         qJZvx8uiRI7PEMCL8HuNpiyxuD0ghY84AyXLLnDfTFi/67YKFX1aZiNppyVNVRFj6+
         xGnt3IGgZgPO3pwctuiNZEP8nMCnJ0XfaSzcuC9Y=
Date:   Tue, 07 Mar 2023 17:05:30 -0800
To:     mm-commits@vger.kernel.org, conor.dooley@microchip.com,
        alex@ghiti.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-alexandre-ghiti-personal-email-address.patch removed from -mm tree
Message-Id: <20230308010531.40B59C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: .mailmap: add Alexandre Ghiti personal email address
has been removed from the -mm tree.  Its filename was
     mailmap-add-alexandre-ghiti-personal-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: .mailmap: add Alexandre Ghiti personal email address
Date: Wed, 1 Mar 2023 10:01:32 +0100

I'm no longer employed by Canonical which results in email bouncing so add
an entry to my personal email address.

Link: https://lkml.kernel.org/r/20230301090132.280475-1-alexghiti@rivosinc.com
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-add-alexandre-ghiti-personal-email-address
+++ a/.mailmap
@@ -28,6 +28,7 @@ Alexander Lobakin <alobakin@pm.me> <bloo
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
 Alexandre Belloni <alexandre.belloni@bootlin.com> <alexandre.belloni@free-electrons.com>
+Alexandre Ghiti <alex@ghiti.fr> <alexandre.ghiti@canonical.com>
 Alexei Starovoitov <ast@kernel.org> <alexei.starovoitov@gmail.com>
 Alexei Starovoitov <ast@kernel.org> <ast@fb.com>
 Alexei Starovoitov <ast@kernel.org> <ast@plumgrid.com>
_

Patches currently in -mm which might be from alex@ghiti.fr are


