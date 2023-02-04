Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A492C05027
	for <mm-commits@archiver.kernel.org>; Sat,  4 Feb 2023 01:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjBDBxC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 20:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbjBDBw7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 20:52:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FF915CAF
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 17:52:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E513962046
        for <mm-commits@vger.kernel.org>; Sat,  4 Feb 2023 01:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4829CC433EF;
        Sat,  4 Feb 2023 01:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675475577;
        bh=EDf0ggt+rJgB3ipmGmv8io9LHPS9MKkI03b7HD3nRaA=;
        h=Date:To:From:Subject:From;
        b=SvJeL9SL5QlAxu5uV0JA1Q/gtOGCwVBPWylZPDm2q+/jv5rBuj85DFSJ9jAFkH7Wy
         W45SQ3PnZasRPEkMti644SpjfbjV32lZ5JRBfZXc2Q0iQOz81LZgboa/1Gr1L2UnJb
         VmcnxklRwuaRbASmXLZYdhYwHp41szVxnSp3nKrg=
Date:   Fri, 03 Feb 2023 17:52:55 -0800
To:     mm-commits@vger.kernel.org, aleksandr.mikhalitsyn@canonical.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-alexander-mikhalitsyn.patch removed from -mm tree
Message-Id: <20230204015257.4829CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entry for Alexander Mikhalitsyn
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-alexander-mikhalitsyn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Subject: mailmap: add entry for Alexander Mikhalitsyn
Date: Tue, 31 Jan 2023 13:34:56 +0100

My old email <alexander.mikhalitsyn@virtuozzo.com> isn't working
anymore.

Link: https://lkml.kernel.org/r/20230131123456.192657-1-aleksandr.mikhalitsyn@canonical.com
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-add-entry-for-alexander-mikhalitsyn
+++ a/.mailmap
@@ -25,6 +25,8 @@ Aleksey Gorelov <aleksey_gorelov@phoenix
 Alexander Lobakin <alobakin@pm.me> <alobakin@dlink.ru>
 Alexander Lobakin <alobakin@pm.me> <alobakin@marvell.com>
 Alexander Lobakin <alobakin@pm.me> <bloodyreaper@yandex.ru>
+Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
+Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
 Alexandre Belloni <alexandre.belloni@bootlin.com> <alexandre.belloni@free-electrons.com>
 Alexei Starovoitov <ast@kernel.org> <alexei.starovoitov@gmail.com>
 Alexei Starovoitov <ast@kernel.org> <ast@fb.com>
_

Patches currently in -mm which might be from aleksandr.mikhalitsyn@canonical.com are


