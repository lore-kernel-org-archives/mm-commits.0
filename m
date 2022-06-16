Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A9DC43334
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 20:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378394AbiFPUyl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 16:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiFPUyk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 16:54:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55CF5FF07
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 13:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD4FEB82610
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 20:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E6AC34114;
        Thu, 16 Jun 2022 20:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655412875;
        bh=v+vXMmzhRowBh6/zD8IBgYTmov3LotkbgOoGkfbT/kU=;
        h=Date:To:From:Subject:From;
        b=kUUVLlZgUjS+g8YjLEGuGhEVUovTLtVCTuRYSq8XgehYJ2I5Npf+KcGJ8K9JTy8/d
         zSp0jEUPhqTSMH7qPggWqDDYXeY9N3zxuT/K1R+16ANif6VWmp3oRtgrZhVTYAuU6+
         AjZQN7dq2ZooAGxyL91TEM0ywhtRC5kNS1O0yBXs=
Date:   Thu, 16 Jun 2022 13:54:34 -0700
To:     mm-commits@vger.kernel.org, axboe@kernel.dk, ansuelsmth@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-christian-marangi.patch added to mm-hotfixes-unstable branch
Message-Id: <20220616205435.67E6AC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for Christian Marangi
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-christian-marangi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-christian-marangi.patch

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
From: Christian Marangi <ansuelsmth@gmail.com>
Subject: mailmap: add entry for Christian Marangi
Date: Thu, 16 Jun 2022 00:50:12 +0200

Add entry to map ansuelsmth@gmail.com to the unique identity of
Christian Marangi.

Link: https://lkml.kernel.org/r/20220615225012.18782-1-ansuelsmth@gmail.com
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-christian-marangi
+++ a/.mailmap
@@ -87,6 +87,7 @@ Christian Borntraeger <borntraeger@linux
 Christian Brauner <brauner@kernel.org> <christian@brauner.io>
 Christian Brauner <brauner@kernel.org> <christian.brauner@canonical.com>
 Christian Brauner <brauner@kernel.org> <christian.brauner@ubuntu.com>
+Christian Marangi <ansuelsmth@gmail.com>
 Christophe Ricard <christophe.ricard@gmail.com>
 Christoph Hellwig <hch@lst.de>
 Colin Ian King <colin.king@intel.com> <colin.king@canonical.com>
_

Patches currently in -mm which might be from ansuelsmth@gmail.com are

mailmap-add-entry-for-christian-marangi.patch

