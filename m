Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE28ECAAA2
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 21:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiH1VFL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Aug 2022 17:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiH1VDj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 28 Aug 2022 17:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB3831205
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 14:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A8F460E9A
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 21:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A36BC433D7;
        Sun, 28 Aug 2022 21:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720615;
        bh=aS4oNegE1o+MxLC5TSDXd4+GqqP/U7wMxYo8N70JP8U=;
        h=Date:To:From:Subject:From;
        b=d64c8TEm96HrNO7e3cjzWywGwW3xEAxawFscSA7tyZR2Zb2d2yoTP2gULaMg1gKgT
         tx92jDvCXKKMW6skB8df2EXAZopAK2XrKKTAFDvjKJRRkvJ1UAlXV2hqr9iVbqA1G8
         msNnxPU54qI8ra4TuiHhlCuy5aK3DfXhBUCBmjPc=
Date:   Sun, 28 Aug 2022 14:03:34 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mailmap-update-email-address-for-colin-king.patch removed from -mm tree
Message-Id: <20220828210335.4A36BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update email address for Colin King
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-colin-king.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mailmap: update email address for Colin King
Date: Wed, 17 Aug 2022 22:27:53 +0100

Colin King is working on kernel janitorial fixes in his spare time and
using his Intel email is confusing.  Use his gmail account as the default
email address.

Link: https://lkml.kernel.org/r/20220817212753.101109-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/.mailmap~mailmap-update-email-address-for-colin-king
+++ a/.mailmap
@@ -98,8 +98,7 @@ Christian Brauner <brauner@kernel.org> <
 Christian Marangi <ansuelsmth@gmail.com>
 Christophe Ricard <christophe.ricard@gmail.com>
 Christoph Hellwig <hch@lst.de>
-Colin Ian King <colin.king@intel.com> <colin.king@canonical.com>
-Colin Ian King <colin.king@intel.com> <colin.i.king@gmail.com>
+Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


