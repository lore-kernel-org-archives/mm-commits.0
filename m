Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A60CCA47E
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379739AbiFQCM4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379692AbiFQCMd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25807BAF
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B628561C50
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABB8C34114;
        Fri, 17 Jun 2022 02:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431950;
        bh=efbj/Pck+rBIBo2fw0XQh6AYoytnOBT3+7/YuIVGCqA=;
        h=Date:To:From:Subject:From;
        b=ojt7KpjzZdnUH+txbJHKHT772VQkb884jNc66SUZhnsj+Md5pIK+MgUBqdiHPST6H
         ViU5t4ghLYKY1ZHHnhoiHpC3+JRkwvbbCEyh/z2uTTn/h/Q09z9DBroARc/H4NCWM6
         C8oIP4XwgQxE0ZLIA/+5Z2D0fKPoDD+066BIrK9w=
Date:   Thu, 16 Jun 2022 19:12:29 -0700
To:     mm-commits@vger.kernel.org, axboe@kernel.dk, ansuelsmth@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-christian-marangi.patch removed from -mm tree
Message-Id: <20220617021230.1ABB8C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entry for Christian Marangi
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-christian-marangi.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


