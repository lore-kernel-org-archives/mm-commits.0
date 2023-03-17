Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045F6C74A5B
	for <mm-commits@archiver.kernel.org>; Fri, 17 Mar 2023 04:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCQE2n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Mar 2023 00:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjCQE2d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Mar 2023 00:28:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D08D497F1
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 21:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0EA2DCE1F32
        for <mm-commits@vger.kernel.org>; Fri, 17 Mar 2023 04:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38271C433D2;
        Fri, 17 Mar 2023 04:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679027304;
        bh=3AIgPZFfhco2GSZ3mnMTtQWKmEqlSf7VsvrUIj+EVP8=;
        h=Date:To:From:Subject:From;
        b=DJn2hCodx8yLDGI/uqpHNMG6JIkxw6iMmZRyGzU6CblYdQ3n2LE+FO45EpAC9iYra
         xfcSo5CQ3KgZBiw4FrMNSwXXKFXU2b7SuR8YXO0gul2gbRnVHAfnHGW0EL6s3KKtTF
         RgXbQ5C1O3gUvzAikFsQHnceMsZM6pwQtjbu3cuU=
Date:   Thu, 16 Mar 2023 21:28:23 -0700
To:     mm-commits@vger.kernel.org, richard.leitner@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-richard-leitner.patch added to mm-hotfixes-unstable branch
Message-Id: <20230317042824.38271C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entries for Richard Leitner
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-richard-leitner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-richard-leitner.patch

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

mailmap-add-entries-for-richard-leitner.patch

