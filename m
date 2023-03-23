Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E569C74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjCWBeR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCWBdl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88160F972
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11C7362387
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67994C433EF;
        Thu, 23 Mar 2023 01:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535148;
        bh=ZrFsfp5pgmqoikHhhNvaHuAjSnhNf/EYHgMf1I5CdAU=;
        h=Date:To:From:Subject:From;
        b=Jh7plXW7mDzHVQRuKTGzXY6ViHG4GdvC9OYwTnkjlgMNwjsi9MsW372F/wUoZy5Dm
         im2ql5eJ7seNrxfRa+QkU45xklsT1MJqZ9V5zYl2hRzizvqkQyPFuXfZRHgEJmIZVX
         bhzQLYodzAvge16G02ZoX1E6HZREfQb1+Mh5DsU8=
Date:   Wed, 22 Mar 2023 18:32:27 -0700
To:     mm-commits@vger.kernel.org, richard.leitner@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entries-for-richard-leitner.patch removed from -mm tree
Message-Id: <20230323013228.67994C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entries for Richard Leitner
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-richard-leitner.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Richard Leitner <richard.leitner@linux.dev>
Subject: mailmap: add entries for Richard Leitner
Date: Thu, 16 Mar 2023 11:25:25 +0100

Map all my old email addresses to my current address.

Link: https://lkml.kernel.org/r/20230316-my-mailmap-v1-1-76bc3a36ba41@linux.dev
Signed-off-by: Richard Leitner <richard.leitner@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-add-entries-for-richard-leitner
+++ a/.mailmap
@@ -382,6 +382,9 @@ Rémi Denis-Courmont <rdenis@simphalempi
 Ricardo Ribalda <ribalda@kernel.org> <ricardo@ribalda.com>
 Ricardo Ribalda <ribalda@kernel.org> Ricardo Ribalda Delgado <ribalda@kernel.org>
 Ricardo Ribalda <ribalda@kernel.org> <ricardo.ribalda@gmail.com>
+Richard Leitner <richard.leitner@linux.dev> <dev@g0hl1n.net>
+Richard Leitner <richard.leitner@linux.dev> <me@g0hl1n.net>
+Richard Leitner <richard.leitner@linux.dev> <richard.leitner@skidata.com>
 Robert Foss <rfoss@kernel.org> <robert.foss@linaro.org>
 Roman Gushchin <roman.gushchin@linux.dev> <guro@fb.com>
 Roman Gushchin <roman.gushchin@linux.dev> <guroan@gmail.com>
_

Patches currently in -mm which might be from richard.leitner@linux.dev are


